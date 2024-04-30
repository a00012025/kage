import 'package:app/features/common/constants.dart';
import 'package:app/contracts/erc20_contract.dart';
import 'package:app/features/home/controllers/user_wallet_controller.dart';
import 'package:app/features/home/domain/balance_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

part 'user_balance_controller.g.dart';

@riverpod
class UserBalance extends _$UserBalance {
  @override
  Future<BalanceData> build() async {
    final wallet = await ref.watch(userWalletProvider.future);
    return getBalance(wallet.walletAddress);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final wallet = await ref.read(userWalletProvider.future);
    final balance = await getBalance(wallet.walletAddress);
    state = AsyncValue.data(balance);
  }
}

var web3Client = Web3Client(Constants.rpcUrl, http.Client());
Future<BalanceData> getBalance(String walletAddress) async {
  if (walletAddress.isEmpty) return BalanceData(usdc: 0, aUsdc: 0);
  final address = EthereumAddress.fromHex(walletAddress);

  final usdcContract = Erc20Contract.create(Constants.usdc);
  final aUsdcContract = Erc20Contract.create(Constants.aUsdc);
  final results = await Future.wait([
    web3Client.call(
      contract: usdcContract,
      function: usdcContract.balanceOf,
      params: [address],
    ),
    web3Client.call(
      contract: aUsdcContract,
      function: aUsdcContract.balanceOf,
      params: [address],
    )
  ]);
  final usdcBalance = (results[0].first as BigInt) / BigInt.from(10).pow(6);
  final aUsdcBalance = (results[1].first as BigInt) / BigInt.from(10).pow(6);
  return BalanceData(usdc: usdcBalance, aUsdc: aUsdcBalance);
}
