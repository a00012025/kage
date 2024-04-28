import 'package:app/utils/app_tap.dart';
import 'package:app/utils/gaps.dart';
import 'package:app/utils/string_utils.dart';
import 'package:app/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SendingTxCard extends StatelessWidget {
  final bool isSuccess;
  final String hash;

  const SendingTxCard({
    super.key,
    required this.isSuccess,
    required this.hash,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppTap(
        onTap: () {
          Clipboard.setData(ClipboardData(text: hash));
          customToast('Copied to clipboard!');
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isSuccess
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 48,
                        )
                      : Image.asset(
                          'assets/icons/ninja_run.gif',
                          width: 200,
                        ),
                  Gaps.h16,
                  Text(
                    isSuccess
                        ? "🥷：Mission Completed! ${hash.toFormattedAddress()}"
                        : "🥷：We're working on it.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
