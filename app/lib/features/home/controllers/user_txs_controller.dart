import 'dart:convert';

import 'package:app/features/common/constants.dart';
import 'package:app/features/common/contract/erc20_contract.dart';
import 'package:app/features/home/domain/tx_data.dart';
import 'package:app/features/home/domain/tx_log.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

part 'user_txs_controller.g.dart';

@Riverpod(keepAlive: true)
class UserTxs extends _$UserTxs {
  Future<void> updateState() async {
    state = await AsyncValue.guard(() async {
      return await getUsdcTxs();
    });
  }

  @override
  FutureOr<List<TxData>> build() {
    state = const AsyncLoading();
    return getUsdcTxs();
  }
}

Future<List<TxData>> getUsdcTxs() async {
  final address = Constants.simpleAccount;
  final paymasterTopic =
      '0x${Constants.payMaster.hex.substring(2).padLeft(64, '0')}';
  final [fromLogs, toLogs] = await Future.wait([
    fetchUsdcTxLogs(address, true),
    fetchUsdcTxLogs(address, false),
  ]);
  final allLogs = [...fromLogs, ...toLogs].where((log) =>
      log.topics[1] != paymasterTopic && log.topics[2] != paymasterTopic);
  // sort by block number
  final sortedLogs = allLogs.toList()
    ..sort(
        (a, b) => (hexToInt(b.blockNumber).compareTo(hexToInt(a.blockNumber))));
  return sortedLogs.map((log) {
    final from = EthereumAddress.fromHex(log.topics[1].substring(26));
    final to = EthereumAddress.fromHex(log.topics[2].substring(26));
    final counterParty = from == address ? to : from;
    final value = hexToInt(log.data) / BigInt.from(10).pow(6);
    return TxData(
        counterParty: counterParty.hex,
        balanceChange: from == address ? -value : value);
  }).toList();
}

Future<List<TxLog>> fetchUsdcTxLogs(EthereumAddress address, bool from) async {
  const String apiUrl = 'https://api.arbiscan.io/api';
  final String apiKey = dotenv.env['ARBISCAN_API_KEY']!;
  final erc20 = Erc20Contract.create(Constants.usdc);
  final transferTopic = bytesToHex(erc20.transferEvent.signature,
      padToEvenLength: true, include0x: true);
  final addressTopic = '0x${address.hex.substring(2).padLeft(64, '0')}';
  final Uri url = from
      ? Uri.parse(
          '$apiUrl?module=logs&action=getLogs&fromBlock=0&toBlock=pending&address=${Constants.usdc.hex}&topic0=$transferTopic&topic0_1_opr=and&topic1=$addressTopic&page=1&offset=0&apikey=$apiKey')
      : Uri.parse(
          '$apiUrl?module=logs&action=getLogs&fromBlock=0&toBlock=pending&address=${Constants.usdc.hex}&topic0=$transferTopic&topic0_2_opr=and&topic2=$addressTopic&page=1&offset=0&apikey=$apiKey');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> results = jsonResponse['result'];
      return results.map((e) => TxLog.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load transaction logs');
    }
  } catch (e) {
    throw Exception('Failed to load transaction logs: $e');
  }
}
