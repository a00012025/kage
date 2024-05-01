import 'dart:convert';
import 'package:bip39/bip39.dart' as bip39;
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
    try {
      final ownerAddress = privateKeyToAddress(privateKey);
      final wallet = WalletData(
        privateKey: privateKey,
        ownerAddress: ownerAddress,
        walletAddress: await getSmartContractWalletAddress(ownerAddress),
      );
      await saveWallet(wallet);
      state = AsyncValue.data(wallet);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> generateNewWallet() async {
    try {
      final mnemonic = bip39.generateMnemonic();
      await importMnemonic(mnemonic);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> importMnemonic(String mnemonic) async {
    try {
      final privateKey = await mnemonicToPrivateKey(mnemonic);
      final ownerAddress = privateKeyToAddress(privateKey);
      final wallet = WalletData(
        mnemonic: mnemonic,
        privateKey: privateKey,
        ownerAddress: ownerAddress,
        walletAddress: await getSmartContractWalletAddress(ownerAddress),
      );
      await saveWallet(wallet);
      state = AsyncValue.data(wallet);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> clear() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'wallet_data');
    state = AsyncValue.data(WalletData.empty());
  }
}

Future<void> saveWallet(WalletData wallet) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: 'wallet_data', value: jsonEncode(wallet.toJson()));
}
