import 'dart:convert';
import 'dart:typed_data';
import 'package:app/contracts/simple_account_factory_contract.dart';
import 'package:app/utils/bip39_wordlist.dart';
import 'package:http/http.dart' as http;
import 'package:app/features/common/constants.dart';
import 'package:web3dart/web3dart.dart';
import 'package:cryptography/cryptography.dart';
import 'package:blockchain_utils/bip/bip/bip32/slip10/bip32_slip10_secp256k1.dart';

bool isValidPrivateKey(String privateKey) {
  try {
    if (privateKey.startsWith('0x') && privateKey.length != 66) {
      return false;
    }
    if (!privateKey.startsWith('0x') && privateKey.length != 64) {
      return false;
    }
    EthPrivateKey.fromHex(privateKey);
    return true;
  } catch (e) {
    return false;
  }
}

bool isValidMnemonic(String mnemonic) {
  final words = mnemonic.split(" ");
  if (words.length != 12) {
    return false;
  }
  return words.every((word) => bip39List.contains(word));
}

String privateKeyToAddress(String privateKey) {
  final priKey = EthPrivateKey.fromHex(privateKey);
  return priKey.address.hex;
}

Future<String> mnemonicToPrivateKey(String mnemonic) async {
  const derivationPath = "m/44'/60'/0'/0/0";
  final seed = await mnemonicToSeed(mnemonic);
  final root = Bip32Slip10Secp256k1.fromSeed(seed);
  final child = root.derivePath(derivationPath);
  if (child.privateKey.raw.isEmpty) {
    throw Exception("child.privateKey is null");
  }
  return child.privateKey.toHex();
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

Future<String> getSmartContractWalletAddress(String owner) async {
  final client = Web3Client(Constants.rpcUrl, http.Client());
  final abContract = SimpleAccountFactoryContract.create();
  final res = await client.call(
    contract: abContract,
    function: abContract.getAddress,
    params: [
      EthereumAddress.fromHex(owner),
      Constants.usdc,
      Constants.payMaster,
      BigInt.zero,
    ],
  );
  return res[0].toString();
}
