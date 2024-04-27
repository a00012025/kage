import 'package:app/features/common/constants.dart';
import 'package:app/features/common/contract/simple_account_factory_contract.dart';
import 'package:app/features/payment/application/payment_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  test('test get Address', () async {
    final client = PaymentService.getWeb3Client();
    final abContract = SimpleAccountFactoryContract.create();

    final res = await client.call(
      contract: abContract,
      function: abContract.getAddress,
      params: [
        EthereumAddress.fromHex(
          "0xc96Cd4B2499E66698fCa30BaB7e0620A7D919807",
        ),
        Constants.usdc,
        Constants.payMaster,
        BigInt.zero,
      ],
    );

    expect(res[0].toString(), Constants.simpleAccount.toString());
  });
}
