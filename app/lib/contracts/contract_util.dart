import 'dart:typed_data';

import 'package:app/contracts/erc20_contract.dart';
import 'package:app/contracts/simple_account_contract.dart';
import 'package:web3dart/web3dart.dart';

Uint8List encodeExecuteFunctionCall(
    {required EthereumAddress address, required List<dynamic> params}) {
  final contract = SimpleAccountContract.create(
    address: address,
  );
  return contract.execute.encodeCall(params);
}

Uint8List encodeExecuteBatchFunctionCall(
    {required EthereumAddress address, required List<dynamic> params}) {
  final contract = SimpleAccountContract.create(
    address: address,
  );
  return contract.executeBatch.encodeCall(params);
}

Uint8List encodeErc20TransferFunctionCall({
  required EthereumAddress contract,
  required EthereumAddress to,
  required BigInt amount,
}) {
  final c = Erc20Contract.create(contract);
  return c.transfer.encodeCall([
    to,
    amount,
  ]);
}

Uint8List encodeErc20ApproveFunctionCall({
  required EthereumAddress contract,
  required EthereumAddress address,
  required BigInt amount,
}) {
  final c = Erc20Contract.create(contract);
  return c.approve.encodeCall([
    address,
    amount,
  ]);
}
