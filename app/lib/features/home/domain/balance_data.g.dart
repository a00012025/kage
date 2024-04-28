// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BalanceDataImpl _$$BalanceDataImplFromJson(Map<String, dynamic> json) =>
    _$BalanceDataImpl(
      usdc: (json['usdc'] as num).toDouble(),
      aUsdc: (json['aUsdc'] as num).toDouble(),
    );

Map<String, dynamic> _$$BalanceDataImplToJson(_$BalanceDataImpl instance) =>
    <String, dynamic>{
      'usdc': instance.usdc,
      'aUsdc': instance.aUsdc,
    };
