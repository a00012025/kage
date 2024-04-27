import 'package:freezed_annotation/freezed_annotation.dart';

part 'tx_log.freezed.dart';
part 'tx_log.g.dart';

@freezed
class TxLog with _$TxLog {
  const factory TxLog({
    required String address,
    required List<String> topics,
    required String data,
    required String blockNumber,
    required String blockHash,
    required String timeStamp,
    required String gasPrice,
    required String gasUsed,
    required String logIndex,
    required String transactionHash,
    required String transactionIndex,
  }) = _TransactionLog;

  factory TxLog.fromJson(Map<String, dynamic> json) => _$TxLogFromJson(json);
}
