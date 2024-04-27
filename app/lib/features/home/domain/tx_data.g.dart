// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tx_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TxDataImpl _$$TxDataImplFromJson(Map<String, dynamic> json) => _$TxDataImpl(
      counterParty: json['counterParty'] as String,
      balanceChange: (json['balanceChange'] as num).toDouble(),
    );

Map<String, dynamic> _$$TxDataImplToJson(_$TxDataImpl instance) =>
    <String, dynamic>{
      'counterParty': instance.counterParty,
      'balanceChange': instance.balanceChange,
    };
