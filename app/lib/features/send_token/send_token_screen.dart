import 'dart:math';

import 'package:app/features/common/sending_tx_card.dart';
import 'package:app/features/home/controllers/user_balance_controller.dart';
import 'package:app/features/home/controllers/user_txs_controller.dart';
import 'package:app/features/home/controllers/user_wallet_controller.dart';
import 'package:app/features/payment/application/payment_service.dart';
import 'package:app/utils/default_button.dart';
import 'package:app/utils/gaps.dart';
import 'package:app/utils/string_utils.dart';
import 'package:app/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web3dart/web3dart.dart';

class SendTokenScreen extends ConsumerStatefulWidget {
  const SendTokenScreen(this.receiver, {super.key});
  final EthereumAddress receiver;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SendTokenScreenState();
}

class _SendTokenScreenState extends ConsumerState<SendTokenScreen> {
  final textEditingController = TextEditingController();

  // initState
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userBalance = ref.watch(userBalanceProvider);
    final remaining = userBalance.value?.total ?? 0;
    final maxAmount = max(remaining - 0.1, 0);

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
            children: [
              DefaultButton(
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // CircleAvatar(
                      //   radius: 12,
                      //   backgroundColor: Colors.white,
                      //   child: Text(
                      //     widget.name[0],
                      //     style: const TextStyle(
                      //       fontSize: 14,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      // ),
                      // Gaps.w8,
                      Text("TO: ${widget.receiver.hex.toFormattedAddress()}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/usdc.png",
                          width: 20,
                        ),
                        Gaps.w4,
                        const Text(
                          "USDC",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Gaps.h32,
                    TextField(
                      autofocus: true,
                      onChanged: (value) => setState(() {}),
                      controller: textEditingController,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: false,
                        decimal: true,
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        border: InputBorder.none,
                      ),
                    ),
                    Gaps.h16,
                    const Text(
                      "Enter the amount you want to send",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    // max amount: maxAmount format with 2 decimals
                    Gaps.h4,
                    Text(
                      "Max: ${(max(maxAmount - 0.005, 0)).toStringAsFixed(2)} USDC",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              DefaultButton(
                isDisable: textEditingController.text.isEmpty,
                showIcon: true,
                onPressed: () async {
                  if (textEditingController.text.isEmpty) {
                    return;
                  }
                  final amountToSend = double.parse(textEditingController.text);
                  if (amountToSend > maxAmount) {
                    customToast('Insufficient balance');
                    return;
                  }

                  await showDialog(
                      context: context,
                      builder: (_) {
                        return SendingTokenCard(
                          receiver: widget.receiver,
                          amount: textEditingController.text,
                        );
                      });
                  ref.read(userBalanceProvider.notifier).refresh();
                  ref.read(userTxsProvider.notifier).refresh();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                text: "Confirm",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SendingTokenCard extends ConsumerStatefulWidget {
  const SendingTokenCard({
    super.key,
    required this.receiver,
    required this.amount,
  });

  final EthereumAddress receiver;
  final String amount;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SendingTokenCardState();
}

class _SendingTokenCardState extends ConsumerState<SendingTokenCard> {
  bool isSuccess = false;
  String hash = '';
  @override
  void initState() {
    asyncInit();

    super.initState();
  }

  void asyncInit() async {
    final service = PaymentService();
    final userWallet = ref.read(userWalletProvider);
    if ((userWallet.value?.walletAddress ?? '').isEmpty) {
      return;
    }
    hash = await service.sendUsdc(
        userWallet.value!, widget.amount, widget.receiver);
    setState(() {
      isSuccess = true;
    });
    debugPrint('=======hash : $hash=========');
  }

  @override
  Widget build(BuildContext context) {
    return SendingTxCard(
      isSuccess: isSuccess,
      hash: hash,
    );
  }
}
