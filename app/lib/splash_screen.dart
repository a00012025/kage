import 'package:app/features/home/controllers/user_wallet_controller.dart';
import 'package:app/features/home/home_screen.dart';
import 'package:app/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(userWalletProvider, (prev, walletData) {
      walletData.when(
        data: (wallet) {
          if (wallet.walletAddress.isNotEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialWithModalsPageRoute(builder: (_) => const HomeScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        },
        loading: () {},
        error: (e, s) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
      );
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
