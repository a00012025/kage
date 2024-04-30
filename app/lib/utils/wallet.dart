import 'dart:convert';
import 'dart:typed_data';

import 'package:web3dart/web3dart.dart';
import 'package:cryptography/cryptography.dart';
import 'package:blockchain_utils/bip/bip/bip32/slip10/bip32_slip10_secp256k1.dart';

String privateKeyToAddress(String privateKey) {
  final priKey = EthPrivateKey.fromHex(privateKey);
  return priKey.address.hex;
}

Future<String> mnemonicToAddress(String mnemonic) async {
  const derivationPath = "m/44'/60'/0'/0/0";
  final seed = await mnemonicToSeed(mnemonic);
  final root = Bip32Slip10Secp256k1.fromSeed(seed);
  final child = root.derivePath(derivationPath);
  if (child.privateKey.raw.isEmpty) {
    throw Exception("child.privateKey is null");
  }
  final privateKey = child.privateKey.toHex();
  final priKey = EthPrivateKey.fromHex(privateKey);
  return priKey.address.hex;
}

// This is for replace bip32.mnemonicToSeed from bip32 package, cause it's too slow
Future<Uint8List> mnemonicToSeed(String mnemonic) async {
  var iterationCount = 2048;
  String saltPrefix = "mnemonic";

  final pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha512(),
    iterations: iterationCount,
    bits: 512,
  );

  final salt = Uint8List.fromList(utf8.encode(saltPrefix));
  final derivedKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(mnemonic.codeUnits), nonce: salt);
  final seed = await derivedKey.extractBytes();
  final uint8Seed = Uint8List.fromList(seed);
  return uint8Seed;
}
