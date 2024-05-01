import 'package:app/features/home/controllers/user_preference_controller.dart';
import 'package:app/features/home/widgets/total_balance.dart';
import 'package:app/utils/gaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AppBarSmall extends ConsumerWidget {
  const AppBarSmall({super.key, required this.balance});
  final double balance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPreference = ref.watch(userPreferenceProvider);
    final isObscureBalance = userPreference.value?.isObscureBalance ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          const Spacer(),
          Text(
            isObscureBalance
                ? getObscureString(5)
                : NumberFormat.decimalPattern()
                    .format(double.parse(balance.toStringAsFixed(2))),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Gaps.w12,
          Image.asset('assets/icons/usdc.png', width: 24),
        ],
      ),
    );
  }
}
