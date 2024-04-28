// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app/features/common/constants.dart';
import 'package:app/features/common/contract/aave_contract.dart';
import 'package:app/features/common/contract/contract_util.dart';
import 'package:app/features/common/contract/entry_point_contract.dart';
import 'package:app/features/common/contract/erc20_contract.dart';
import 'package:app/features/common/contract/simple_account_factory_contract.dart';
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
    return Web3Client('https://rpc.ankr.com/arbitrum', http.Client());
  }

  Future<UserOperation> getDefaultUserOperation(
      EthereumAddress smartContractAccount) async {
    final nonce = await getNonce(smartContractAccount);
    String? initCode;
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

  Future<UserOperation> getSendUsdcUserOperation(
      String amountToSend, EthereumAddress toAddress) async {
    final amount = (double.tryParse(amountToSend) ?? 0.0) * 1e6;
    final rawAmount = BigInt.from(amount);
    final smartContractAccount = Constants.simpleAccount;
    UserOperation op = await getDefaultUserOperation(smartContractAccount);
    final sendCallData = encodeErc20TransferFunctionCall(
      contract: Constants.usdc,
      to: toAddress,
      amount: rawAmount,
    );
    final callData = encodeExecuteFunctionCall(
      address: smartContractAccount,
      params: [Constants.usdc, BigInt.zero, sendCallData],
    );
    op.callData = hexlify(callData);
    op.callGasLimit = BigInt.from(50000);
    return op;
  }

  Future<String> sendUsdc(String sendAmount, EthereumAddress toAddress) async {
    final op = await getSendUsdcUserOperation(sendAmount, toAddress);
    return sendUserOperations([op]);
  }

  Future<String> sendUserOperations(List<UserOperation> ops) async {
    final chain = Chains.getChain(Network.arbitrum);
    for (var i = 0; i < ops.length; i++) {
      if (i > 0) {
        ops[i].nonce = ops[i - 1].nonce + BigInt.one;
      }
      final signature = EthSigUtil.signPersonalMessage(
        privateKey: dotenv.env['WALLET_PRIVATE_KEY']!,
        message: ops[i].hash(chain),
      );
      ops[i].signature = signature;
    }
    final client = getWeb3Client();
    final relayerPrivateKey = dotenv.env['RELAYER_PRIVATE_KEY']!;
    final privateKey = EthPrivateKey.fromHex(relayerPrivateKey);
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
        privateKey.address,
      ],
      maxGas: maxGas,
      maxFeePerGas: await getGasPrice(),
    );
    final hash = await client.sendTransaction(privateKey, transaction,
        chainId: Chains.getChain(Network.arbitrum).chainId);
    return hash;
  }

  Future<String> sendInvestUserOperation(String amountToSend) async {
    final amount = (double.tryParse(amountToSend) ?? 0.0) * 1e6;
    final rawAmount = BigInt.from(amount);
    final client = getWeb3Client();
    final usdcContract = Erc20Contract.create(Constants.usdc);
    final smartContractAccount = Constants.simpleAccount;
    final aaveContract = AaveContract.create();
    final List<UserOperation> ops = [];

    // if allowance is not enough, approve
    final allowance = await client.call(
      contract: usdcContract,
      function: usdcContract.allowance,
      params: [smartContractAccount, Constants.aave],
    );
    if ((allowance.first as BigInt) < rawAmount) {
      final approveCallData = usdcContract.function('approve').encodeCall([
        Constants.aave,
        rawAmount,
      ]);
      final callData = encodeExecuteFunctionCall(
        address: smartContractAccount,
        params: [Constants.usdc, BigInt.zero, approveCallData],
      );
      final approveOp = await getDefaultUserOperation(smartContractAccount);
      approveOp.callData = hexlify(callData);
      approveOp.callGasLimit = BigInt.from(50000);
      ops.add(approveOp);
    }

    // invest user operation
    final investCallData = aaveContract.function('supply').encodeCall([
      Constants.usdc,
      rawAmount,
      smartContractAccount,
      BigInt.zero,
    ]);
    final callData = encodeExecuteFunctionCall(
      address: smartContractAccount,
      params: [Constants.aave, BigInt.zero, investCallData],
    );
    final investOp = await getDefaultUserOperation(smartContractAccount);
    investOp.callData = hexlify(callData);
    investOp.callGasLimit = BigInt.from(500000);
    ops.add(investOp);

    return sendUserOperations(ops);
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
