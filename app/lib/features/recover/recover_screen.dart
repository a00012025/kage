import 'package:app/features/home/controllers/user_wallet_controller.dart';
import 'package:app/features/home/home_screen.dart';
import 'package:app/utils/default_button.dart';
import 'package:app/utils/gaps.dart';
import 'package:app/utils/toast.dart';
import 'package:app/utils/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RecoverScreen extends ConsumerStatefulWidget {
  const RecoverScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecoverScreenState();
}

class _RecoverScreenState extends ConsumerState<RecoverScreen> {
  final textEditingController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(userWalletProvider, (prev, walletData) {
      walletData.when(
        data: (data) {
          if (data.walletAddress.isNotEmpty) {
            customToast('Import successfully');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialWithModalsPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          } else {
            setState(() {
              loading = false;
            });
          }
        },
        loading: () {},
        error: (e, s) {
          customToast('Failed to import wallet', showIcon: false);
          setState(() {
            loading = false;
          });
        },
      );
    });

    // final walletData = ref.watch(userWalletProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Import Wallet',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Gaps.h12,
              const Text(
                'Enter your 12-word recovery phrase or private key',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Gaps.h32,
              TextField(
                autofocus: true,
                onChanged: (value) => setState(() {}),
                controller: textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
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
              const Spacer(),
              DefaultButton(
                onPressed: () {
                  final input = textEditingController.text.trim();
                  if (isValidPrivateKey(input)) {
                    setState(() {
                      loading = true;
                    });
                    ref
                        .read(userWalletProvider.notifier)
                        .importPrivateKey(input);
                  } else if (isValidMnemonic(input)) {
                    setState(() {
                      loading = true;
                    });
                    ref.read(userWalletProvider.notifier).importMnemonic(input);
                  } else {
                    customToast('Invalid recovery phrase or private key',
                        showIcon: false);
                  }
                },
                isDisable: textEditingController.text.isEmpty || loading,
                text: 'Import',
              )
            ],
          ),
        ),
      ),
    );
  }
}
