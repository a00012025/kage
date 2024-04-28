import 'package:web3dart/web3dart.dart';

class Constants {
  static EthereumAddress entrypoint = EthereumAddress.fromHex(
    "0x0000000071727De22E5E9d8BAf0edAc6f37da032",
  );
  static EthereumAddress zeroAddress =
      EthereumAddress.fromHex("0x0000000000000000000000000000000000000000");

  static EthereumAddress simpleAccountFactory = EthereumAddress.fromHex(
    "0x12E49fFC4A46514d3FdEae7Dfe8cc004ed8262cA",
  );

  // FIXME: derive from private key
  static EthereumAddress simpleAccountOwner =
      EthereumAddress.fromHex('0xcf60Ca2Bc16FA2B47c0898FA998b3b167C4F3907');

  // FIXME: derive from private key
  static EthereumAddress simpleAccount = EthereumAddress.fromHex(
    "0xA80DC1b0f4109d3440dD5c20835bE08902f56b19",
  );

  static EthereumAddress usdc = EthereumAddress.fromHex(
    "0xaf88d065e77c8cC2239327C5EDb3A432268e5831",
  );

  static EthereumAddress aave = EthereumAddress.fromHex(
    "0x794a61358d6845594f94dc1db02a252b5b4814ad",
  );

  static EthereumAddress aUsdc = EthereumAddress.fromHex(
    "0x724dc807b04555b71ed48a6896b6F41593b8C637",
  );

  static EthereumAddress payMaster = EthereumAddress.fromHex(
    "0xf2fc6e2ee4f90bd51cdf403b7dcac6b7fb12e6f9",
  );

  static EthereumAddress aaveUiPoolDataProvider = EthereumAddress.fromHex(
    "0x145dE30c929a065582da84Cf96F88460dB9745A7",
  );

  static EthereumAddress aavePoolAddressesProvider = EthereumAddress.fromHex(
    "0xa97684ead0e402dC232d5A977953DF7ECBaB3CDb",
  );

  Constants._();
}
