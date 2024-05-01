import 'package:app/export_wallet_screen.dart';
import 'package:app/extension/context_extension.dart';
import 'package:app/features/common/single_page_custom_scaffold.dart';
import 'package:app/features/home/controllers/user_wallet_controller.dart';
import 'package:app/login_screen.dart';
import 'package:app/utils/default_button.dart';
import 'package:app/utils/gaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SinglePageCustomScaffold(
      isModalStyle: true,
      height: context.height * 0.88,
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gaps.h32,
            DefaultButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacement(CupertinoModalBottomSheetRoute(
                  builder: (context) => const ExportWalletScreen(),
                  closeProgressThreshold: 0.9,
                  expanded: false,
                  duration: 260.milliseconds,
                ));
              },
              text: 'Export Wallet',
              shimmer: false,
            ),
            Gaps.h12,
            DefaultButton(
              onPressed: () {
                ref.read(userWalletProvider.notifier).clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              text: 'Logout',
              shimmer: false,
              textStyle: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Colors.white,
              borderColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
