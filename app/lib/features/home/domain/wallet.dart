import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web3dart/web3dart.dart';

part 'wallet.freezed.dart';
part 'wallet.g.dart';

@freezed
class WalletData with _$WalletData {
  const WalletData._();

  const factory WalletData({
    String? mnemonic,
    required String privateKey,
    required String ownerAddress,
    required String walletAddress,
  }) = _WalletData;

  factory WalletData.fromJson(Map<String, dynamic> json) =>
      _$WalletDataFromJson(json);

  factory WalletData.empty() => const WalletData(
        mnemonic: null,
        privateKey: '',
        ownerAddress: '',
        walletAddress: '',
      );

  get owner => EthereumAddress.fromHex(ownerAddress);
  get account => EthereumAddress.fromHex(walletAddress);
}
