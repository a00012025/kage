// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userdata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDataImpl _$$UserDataImplFromJson(Map<String, dynamic> json) =>
    _$UserDataImpl(
      name: json['name'] as String,
      privateKey: json['privateKey'] as String? ?? "",
      totalBalance: json['totalBalance'] as String? ?? "0",
    );

Map<String, dynamic> _$$UserDataImplToJson(_$UserDataImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'privateKey': instance.privateKey,
      'totalBalance': instance.totalBalance,
    };
