// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletDataImpl _$$WalletDataImplFromJson(Map<String, dynamic> json) =>
    _$WalletDataImpl(
      mnemonic: json['mnemonic'] as String?,
      privateKey: json['privateKey'] as String?,
      ownerAddress: json['ownerAddress'] as String,
      walletAddress: json['walletAddress'] as String,
    );

Map<String, dynamic> _$$WalletDataImplToJson(_$WalletDataImpl instance) =>
    <String, dynamic>{
      'mnemonic': instance.mnemonic,
      'privateKey': instance.privateKey,
      'ownerAddress': instance.ownerAddress,
      'walletAddress': instance.walletAddress,
    };
