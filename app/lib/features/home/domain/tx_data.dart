import 'package:freezed_annotation/freezed_annotation.dart';

part 'tx_data.freezed.dart';
part 'tx_data.g.dart';

@freezed
class TxData with _$TxData {
  const factory TxData({
    required String counterParty,
    required double balanceChange,
  }) = _TxData;

  factory TxData.fromJson(Map<String, dynamic> json) => _$TxDataFromJson(json);
}
