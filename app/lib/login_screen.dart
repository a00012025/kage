import 'package:app/features/home/controllers/user_wallet_controller.dart';
import 'package:app/features/home/home_screen.dart';
import 'package:app/features/recover/recover_screen.dart';
import 'package:app/utils/default_button.dart';
import 'package:app/utils/gaps.dart';
import 'package:app/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(userWalletProvider, (prev, walletData) {
      walletData.when(
        data: (data) {
          if (data.walletAddress.isNotEmpty) {
            customToast('Create successfully');
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
          customToast('Something went wrong, please try again',
              showIcon: false);
          setState(() {
            loading = false;
          });
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Gaps.h64,
              const Text(
                "🌗",
                style: TextStyle(fontSize: 48),
                textAlign: TextAlign.center,
              ),
              Gaps.h12,
              Text(
                'Take Charge of Your Savings',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Gaps.h4,
              Text(
                'Smart, Secure, Yours.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              DefaultButton(
                showIcon: false,
                isDisable: loading,
                onPressed: () {
                  ref.read(userWalletProvider.notifier).generateNewWallet();
                  setState(() {
                    loading = true;
                  });
                },
                text: "I'm New Here",
              ),
              Gaps.h16,
              DefaultButton(
                showIcon: false,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecoverScreen(),
                    ),
                  );
                },
                text: "I already have a wallet",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
