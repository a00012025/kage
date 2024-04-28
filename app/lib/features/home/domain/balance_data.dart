import 'package:freezed_annotation/freezed_annotation.dart';

part 'balance_data.freezed.dart';
part 'balance_data.g.dart';

@freezed
class BalanceData with _$BalanceData {
  BalanceData._();

  factory BalanceData({
    required double usdc,
    required double aUsdc,
  }) = _BalanceData;

  factory BalanceData.fromJson(Map<String, dynamic> json) =>
      _$BalanceDataFromJson(json);

  double get total => usdc + aUsdc;
}
