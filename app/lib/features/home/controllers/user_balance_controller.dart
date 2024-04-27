import 'package:app/features/common/constants.dart';
import 'package:app/features/common/contract/erc20_contract.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

part 'user_balance_controller.g.dart';

@Riverpod(keepAlive: true)
class UserBalance extends _$UserBalance {
  Future<void> updateState() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await getUsdcBalance();
    });
  }

  @override
  FutureOr<double> build() {
    state = const AsyncLoading();
    return getUsdcBalance();
  }
}

var web3Client = Web3Client('https://rpc.ankr.com/arbitrum', http.Client());
Future<double> getUsdcBalance() async {
  final address = Constants.simpleAccount;
  final erc20 = Erc20Contract.create();
  final res = await web3Client.call(
    contract: erc20,
    function: erc20.balanceOf,
    params: [
      address,
    ],
  );
  final rawValue = res.first as BigInt;
  return rawValue / BigInt.from(10).pow(6);
}
