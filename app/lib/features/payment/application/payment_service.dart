// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app/features/common/constants.dart';
import 'package:app/contracts/aave_contract.dart';
import 'package:app/contracts/contract_util.dart';
import 'package:app/contracts/entry_point_contract.dart';
import 'package:app/contracts/erc20_contract.dart';
import 'package:app/contracts/simple_account_factory_contract.dart';
import 'package:app/features/home/domain/wallet.dart';
import 'package:app/features/payment/domain/chain.dart';
import 'package:app/features/payment/domain/user_operation.dart';
import 'package:eth_sig_util/eth_sig_util.dart';
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
    return Web3Client(Constants.rpcUrl, http.Client());
  }

  Future<UserOperation> getDefaultUserOperation(
    EthereumAddress ownerAddress,
    EthereumAddress smartContractAccount, {
    BigInt? nonce,
  }) async {
    nonce ??= await getNonce(smartContractAccount);
    String? initCode;
    if (nonce == BigInt.zero) {
      final createAccountCallData =
          simpleAccountFactoryContract.function('createAccount').encodeCall([
        ownerAddress,
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
    return UserOperation.partial(
      initCode: initCode,
      nonce: nonce,
      callData: "0x",
      paymasterAndData: paymasterAndData,
      sender: smartContractAccount,
      verificationGasLimit:
          nonce == BigInt.zero ? BigInt.from(400000) : BigInt.from(150000),
      callGasLimit: BigInt.from(50000),
      preVerificationGas: BigInt.from(40000),
    );
  }

  Future<String> sendUsdc(
    WalletData walletData,
    String sendAmount,
    EthereumAddress toAddress,
  ) async {
    final List<UserOperation> ops = [];
    final amount = (double.tryParse(sendAmount) ?? 0.0) * 1e6;
    final rawAmount = BigInt.from(amount);
    final usdcContract = Erc20Contract.create(Constants.usdc);
    final client = getWeb3Client();
    final usdcBalance = (await client.call(
      contract: usdcContract,
      function: usdcContract.balanceOf,
      params: [walletData.account],
    ))
        .first as BigInt;
    final minLeftAmount = BigInt.from(0.1 * 1e6);
    if (usdcBalance - rawAmount < minLeftAmount) {
      // need to withdraw first if usdc balance will be less than 0.1
      final aaveContract = AaveContract.create();
      final toWithdraw = rawAmount - usdcBalance + minLeftAmount;
      final withdrawCallData = aaveContract.function('withdraw').encodeCall([
        Constants.usdc,
        toWithdraw,
        walletData.account,
      ]);
      final callData = encodeExecuteFunctionCall(
        address: walletData.account,
        params: [Constants.aave, BigInt.zero, withdrawCallData],
      );
      final withdrawOp =
          await getDefaultUserOperation(walletData.owner, walletData.account);
      withdrawOp.callData = hexlify(callData);
      withdrawOp.callGasLimit = BigInt.from(300000);
      ops.add(withdrawOp);
    }

    UserOperation sendOp = await getDefaultUserOperation(
        walletData.owner, walletData.account,
        nonce: ops.isEmpty ? null : ops.last.nonce + BigInt.one);
    final sendCallData = encodeErc20TransferFunctionCall(
      contract: Constants.usdc,
      to: toAddress,
      amount: rawAmount,
    );
    final callData = encodeExecuteFunctionCall(
      address: walletData.account,
      params: [Constants.usdc, BigInt.zero, sendCallData],
    );
    sendOp.callData = hexlify(callData);
    sendOp.callGasLimit = BigInt.from(50000);
    ops.add(sendOp);
    return sendUserOperations(ops, walletData.privateKey);
  }

  Future<String> sendInvestUserOperation(
    WalletData walletData,
    String amountToSend,
  ) async {
    final amount = (double.tryParse(amountToSend) ?? 0.0) * 1e6;
    final rawAmount = BigInt.from(amount);
    final client = getWeb3Client();
    final usdcContract = Erc20Contract.create(Constants.usdc);
    final aaveContract = AaveContract.create();
    final List<UserOperation> ops = [];

    // if allowance is not enough, approve
    final allowance = await client.call(
      contract: usdcContract,
      function: usdcContract.allowance,
      params: [walletData.account, Constants.aave],
    );
    if ((allowance.first as BigInt) < rawAmount) {
      final approveCallData = usdcContract.function('approve').encodeCall([
        Constants.aave,
        rawAmount,
      ]);
      final callData = encodeExecuteFunctionCall(
        address: walletData.account,
        params: [Constants.usdc, BigInt.zero, approveCallData],
      );
      final approveOp =
          await getDefaultUserOperation(walletData.owner, walletData.account);
      approveOp.callData = hexlify(callData);
      approveOp.callGasLimit = BigInt.from(50000);
      ops.add(approveOp);
    }

    // invest user operation
    final investCallData = aaveContract.function('supply').encodeCall([
      Constants.usdc,
      rawAmount,
      walletData.account,
      BigInt.zero,
    ]);
    final callData = encodeExecuteFunctionCall(
      address: walletData.account,
      params: [Constants.aave, BigInt.zero, investCallData],
    );
    final investOp = await getDefaultUserOperation(
        walletData.owner, walletData.account,
        nonce: ops.isEmpty ? null : ops.last.nonce + BigInt.one);
    investOp.callData = hexlify(callData);
    investOp.callGasLimit = BigInt.from(500000);
    ops.add(investOp);

    return sendUserOperations(ops, walletData.privateKey);
  }

  Future<String> sendUserOperations(
      List<UserOperation> ops, String privateKey) async {
    final chain = Chains.getChain(Network.arbitrum);
    for (var i = 0; i < ops.length; i++) {
      final signature = EthSigUtil.signPersonalMessage(
        privateKey: privateKey,
        message: ops[i].hash(chain),
      );
      ops[i].signature = signature;
    }
    final client = getWeb3Client();
    final relayerPrivateKey = dotenv.env['RELAYER_PRIVATE_KEY']!;
    final relayerPriKey = EthPrivateKey.fromHex(relayerPrivateKey);
    final maxGas = 200000 * ops.length +
        ops.fold<int>(
            0,
            (previousValue, e) =>
                previousValue +
                e.callGasLimit.toInt() +
                e.preVerificationGas.toInt() +
                e.verificationGasLimit.toInt());
    final transaction = Transaction.callContract(
      contract: entryPointContract,
      function: entryPointContract.handleOps,
      parameters: [
        ops.map((e) => e.toList()).toList(),
        relayerPriKey.address,
      ],
      maxGas: maxGas,
      maxFeePerGas: await getGasPrice(),
    );
    final hash = await client.sendTransaction(relayerPriKey, transaction,
        chainId: Chains.getChain(Network.arbitrum).chainId);
    return hash;
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

  Future<EtherAmount> getGasPrice() async {
    final client = getWeb3Client();
    final gasPrice = await client.getGasPrice();
    final higherGasPrice = (gasPrice.getInWei.toDouble() * 1.2).toString();
    final finalGasPrice = BigInt.parse(higherGasPrice.split('.')[0]);
    return EtherAmount.inWei(finalGasPrice);
  }
}

String hexlify(List<int> intArray) {
  var ss = <String>[];
  for (int value in intArray) {
    ss.add(value.toRadixString(16).padLeft(2, '0'));
  }
  return "0x${ss.join('')}";
}
