import 'package:app/utils/wallet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test get Address', () async {
    final actualWallet = await getSmartContractWalletAddress(
        '0xcf60Ca2Bc16FA2B47c0898FA998b3b167C4F3907');
    expect(actualWallet.toLowerCase(),
        '0xA80DC1b0f4109d3440dD5c20835bE08902f56b19'.toLowerCase());
  });
}
