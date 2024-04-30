import 'dart:convert';

import 'package:app/features/home/domain/wallet.dart';
import 'package:app/utils/wallet.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'user_wallet_controller.g.dart';

@Riverpod(keepAlive: true)
class UserWallet extends _$UserWallet {
  @override
  Future<WalletData> build() async {
    state = const AsyncLoading();
    const storage = FlutterSecureStorage();
    final data = await storage.read(key: 'wallet_data');
    if (data == null) {
      return WalletData.empty();
    }
    return WalletData.fromJson(jsonDecode(data));
  }

  Future<void> importPrivateKey(String privateKey) async {
    final ownerAddress = privateKeyToAddress(privateKey);
    final wallet = WalletData(
      privateKey: privateKey,
      ownerAddress: ownerAddress,
      walletAddress: '0x1234',
    );
    await saveWallet(wallet);
    state = AsyncValue.data(wallet);
  }

  Future<void> importMnemonic(String mnemonic) async {
    final ownerAddress = await mnemonicToAddress(mnemonic);
    final wallet = WalletData(
      mnemonic: mnemonic,
      ownerAddress: ownerAddress,
      walletAddress: '0x1234',
    );
    state = AsyncValue.data(wallet);
  }
}

Future<void> saveWallet(WalletData wallet) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: 'wallet_data', value: jsonEncode(wallet.toJson()));
}
