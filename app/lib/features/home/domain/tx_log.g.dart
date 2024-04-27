// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tx_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionLogImpl _$$TransactionLogImplFromJson(Map<String, dynamic> json) =>
    _$TransactionLogImpl(
      address: json['address'] as String,
      topics:
          (json['topics'] as List<dynamic>).map((e) => e as String).toList(),
      data: json['data'] as String,
      blockNumber: json['blockNumber'] as String,
      blockHash: json['blockHash'] as String,
      timeStamp: json['timeStamp'] as String,
      gasPrice: json['gasPrice'] as String,
      gasUsed: json['gasUsed'] as String,
      logIndex: json['logIndex'] as String,
      transactionHash: json['transactionHash'] as String,
      transactionIndex: json['transactionIndex'] as String,
    );

Map<String, dynamic> _$$TransactionLogImplToJson(
        _$TransactionLogImpl instance) =>
    <String, dynamic>{
      'address': instance.address,
      'topics': instance.topics,
      'data': instance.data,
      'blockNumber': instance.blockNumber,
      'blockHash': instance.blockHash,
      'timeStamp': instance.timeStamp,
      'gasPrice': instance.gasPrice,
      'gasUsed': instance.gasUsed,
      'logIndex': instance.logIndex,
      'transactionHash': instance.transactionHash,
      'transactionIndex': instance.transactionIndex,
    };
