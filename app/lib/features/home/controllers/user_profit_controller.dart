import 'package:app/features/common/constants.dart';
import 'package:app/features/home/controllers/user_balance_controller.dart';
import 'package:app/features/home/controllers/user_txs_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_profit_controller.g.dart';

@riverpod
Future<double> userProfit(UserProfitRef ref) async {
  final userTxs = await ref.watch(userTxsProvider.future);
  final userBalance = await ref.watch(userBalanceProvider.future);
  final netBalance = userTxs.fold<double>(
      0,
      (previousValue, element) =>
          previousValue +
          (element.counterParty.toLowerCase() == Constants.aUsdc.hex
              ? element.balanceChange
              : 0));
  return userBalance.aUsdc + netBalance;
}
