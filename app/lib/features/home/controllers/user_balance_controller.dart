import 'package:app/features/common/constants.dart';
import 'package:app/features/common/contract/erc20_contract.dart';
import 'package:app/features/home/domain/balance_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

part 'user_balance_controller.g.dart';

@Riverpod(keepAlive: true)
class UserBalance extends _$UserBalance {
  Future<void> updateState() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await getBalance();
    });
  }

  @override
  FutureOr<BalanceData> build() {
    state = const AsyncLoading();
    return getBalance();
  }
}

var web3Client = Web3Client(Constants.rpcUrl, http.Client());
Future<BalanceData> getBalance() async {
  final address = Constants.simpleAccount;
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
