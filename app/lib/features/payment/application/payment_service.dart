// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:app/features/common/constants.dart';
import 'package:app/features/common/contract/contract_util.dart';
import 'package:app/features/common/contract/entry_point_contract.dart';
import 'package:app/features/common/contract/simple_account_factory_contract.dart';
import 'package:app/features/payment/application/payment_exception.dart';
import 'package:app/features/payment/domain/chain.dart';
import 'package:app/features/payment/domain/user_operation.dart';
import 'package:app/features/payment/domain/utxo_address.dart';
import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class PaymentService {
  final EntryPointContract entryPointContract;
  final SimpleAccountFactoryContract simpleAccountFactoryContract;
  PaymentService()
      : entryPointContract = EntryPointContract.create(),
        simpleAccountFactoryContract = SimpleAccountFactoryContract.create();

  static Web3Client getWeb3Client() {
    return Web3Client('https://rpc.ankr.com/arbitrum', http.Client());
  }

  Future<List<UtxoAddress>> getAddressesToSend({
    required List<UtxoAddress> addresses,
    required BigInt amountToSend,
  }) async {
    var sortedAddresses = List<UtxoAddress>.from(addresses)
      ..sort((a, b) => b.balance.compareTo(a.balance));
    BigInt needFound = amountToSend;
    BigInt tempFound = BigInt.zero;

    List<UtxoAddress> selectedAddresses = [];
    for (var utxo in sortedAddresses) {
      tempFound = needFound;
      needFound -= utxo.balance;
      if (needFound <= BigInt.zero) {
        selectedAddresses.add(utxo.copyWith(
          balance: tempFound,
        ));
        break;
      } else {
        selectedAddresses.add(utxo);
      }
    }

    if (needFound > BigInt.zero) {
      final exception = InsufficientBalanceException(
        availableBalance: needFound,
        requiredBalance: amountToSend,
      );
      debugPrint(exception.toString());
      throw exception;
    }

    return selectedAddresses;
  }

  Future<UserOperation> signUserOperations(
      BigInt amountToSend, EthereumAddress toAddress) async {
    final smartContractAccount = Constants.simpleAccount;

    final sendCallData = encodeErc20TransferFunctionCall(
      to: toAddress,
      amount: amountToSend,
    );
    final callData = encodeExecuteFunctionCall(
      address: smartContractAccount,
      params: [Constants.usdc, BigInt.zero, sendCallData],
    );
    final nonce = await getNonce(smartContractAccount);
    debugPrint('=======nonce : $nonce=========');
    String? initCode; // "0xa0371bd6aeccfee005b49709738e49abce65561d"
    if (nonce == BigInt.zero) {
      final createAccountCallData =
          simpleAccountFactoryContract.function('createAccount').encodeCall([
        Constants.simpleAccountOwner,
        Constants.usdc,
        Constants.payMaster,
        BigInt.zero,
      ]);
      initCode =
          '${Constants.simpleAccountFactory.toString()}${bytesToHex(createAccountCallData)}';
    }

    const paymasterVerificationGasLimit = 100000;
    const paymasterPostOpGasLimit = 100000;
    final paymasterAndData =
        "${Constants.payMaster.toString()}${paymasterVerificationGasLimit.toRadixString(16).padLeft(32, '0')}${paymasterPostOpGasLimit.toRadixString(16).padLeft(32, '0')}";

    final op = UserOperation.partial(
      initCode: initCode,
      nonce: nonce,
      callData: hexlify(callData),
      paymasterAndData: paymasterAndData,
      sender: smartContractAccount,
      verificationGasLimit:
          nonce == BigInt.zero ? BigInt.from(400000) : BigInt.from(150000),
      callGasLimit: BigInt.from(50000),
      preVerificationGas: BigInt.from(40000),
    );

    final chain = Chains.getChain(Network.arbitrum);
    log("op.hash(chain): ${bytesToHex(op.hash(chain), include0x: true)}");
    final signature = EthSigUtil.signPersonalMessage(
      privateKey: dotenv.env['WALLET_PRIVATE_KEY']!,
      message: op.hash(chain),
    );

    op.signature = signature;

    return op;
  }

  Future<List<UserOperation>> getUserOperations(
      String amountToSend, EthereumAddress toAddress) async {
    final amount = (double.tryParse(amountToSend) ?? 0.0) * 1000000;
    final rawAmount = BigInt.from(amount);

    List<UserOperation> ops = [];
    final op = await signUserOperations(
      rawAmount,
      toAddress,
    );
    ops.add(op);
    return ops;
  }

  Future<String> sendUserOperation(
      String sendAmount, EthereumAddress toAddress) async {
    final ops = await getUserOperations(sendAmount, toAddress);
    final client = getWeb3Client();
    final relayerPrivateKey = dotenv.env['RELAYER_PRIVATE_KEY']!;
    final privateKey = EthPrivateKey.fromHex(relayerPrivateKey);
    final gasPrice = await client.getGasPrice();
    final higherGasPrice = (gasPrice.getInWei.toDouble() * 1.2).toString();
    final finalGasPrice = BigInt.parse(higherGasPrice.split('.')[0]);

    final transaction = Transaction.callContract(
      contract: entryPointContract,
      function: entryPointContract.handleOps,
      parameters: [
        ops.map((e) => e.toList()).toList(),
        privateKey.address,
      ],
      maxGas: 1000000,
      maxFeePerGas: EtherAmount.inWei(finalGasPrice),
    );
    final hash = await client.sendTransaction(privateKey, transaction,
        chainId: Chains.getChain(Network.arbitrum).chainId);
    return hash;
  }

  String hexlify(List<int> intArray) {
    var ss = <String>[];
    for (int value in intArray) {
      ss.add(value.toRadixString(16).padLeft(2, '0'));
    }
    return "0x${ss.join('')}";
  }

  Future<BigInt> getNonce(EthereumAddress address) async {
    final client = getWeb3Client();

    final nonce = await client.call(
        contract: entryPointContract,
        function: entryPointContract.getNonce,
        params: [
          address,
          BigInt.zero,
        ]);
    return nonce.first;
  }
}
