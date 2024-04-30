import 'package:app/features/common/constants.dart';
import 'package:app/contracts/aave_ui_pool_data_contract.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

part 'aave_data_controller.g.dart';

@Riverpod(keepAlive: true)
class AaveData extends _$AaveData {
  Future<void> updateState() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await getApy();
    });
  }

  @override
  FutureOr<double> build() {
    state = const AsyncLoading();
    return getApy();
  }
}

var web3Client = Web3Client(Constants.rpcUrl, http.Client());
Future<double> getApy() async {
  final aaveUiContract = AaveUiPoolDataContract.create();
  final result = await web3Client.call(
    contract: aaveUiContract,
    function: aaveUiContract.getReservesData,
    params: [Constants.aavePoolAddressesProvider],
  );
  final poolDatas = result.first as List<dynamic>;
  final usdcPoolData = poolDatas.firstWhere(
          (poolData) => poolData[0] as EthereumAddress == Constants.usdc)
      as List<dynamic>;
  return ((usdcPoolData[15] as BigInt) ~/ BigInt.from(10).pow(20)).toDouble() /
      1e7;
}
