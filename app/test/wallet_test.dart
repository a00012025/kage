import 'package:app/utils/wallet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test get Address', () async {
    const mnemonic =
        'test test test test test test test test test test test junk';
    final wallet = await mnemonicToAddress(mnemonic);
    expect(wallet.toLowerCase(),
        "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266".toLowerCase());
  });
}
