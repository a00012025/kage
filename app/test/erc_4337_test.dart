import 'package:app/features/common/constants.dart';
import 'package:app/utils/wallet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test get Address', () async {
    final actualWallet = await getSmartContractWalletAddress(
        Constants.simpleAccountOwner.toString());
    expect(actualWallet, Constants.simpleAccount.toString());
  });
}
