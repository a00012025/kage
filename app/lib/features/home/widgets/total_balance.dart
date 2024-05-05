import 'package:app/features/home/controllers/aave_data_controller.dart';
import 'package:app/features/home/controllers/user_profit_controller.dart';
import 'package:intl/intl.dart';
import 'package:app/features/home/controllers/user_balance_controller.dart';
import 'package:app/features/home/controllers/user_preference_controller.dart';
import 'package:app/features/home/domain/jumping_dot.dart';
import 'package:app/utils/gaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TotalBalanceWidget extends ConsumerWidget {
  const TotalBalanceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userBalance = ref.watch(userBalanceProvider);
    final userPreference = ref.watch(userPreferenceProvider);
    final isObscureBalance = userPreference.value?.isObscureBalance ?? false;
    final aaveApy = ref.watch(aaveDataProvider);
    final userProfit = ref.watch(userProfitProvider);
    print('userProfit: $userProfit');

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/usdc.png',
              width: 28,
            ),
            Gaps.w8,

            //richText with decimal
            userBalance.when(
              data: (value) {
                final balance = value.total.toStringAsFixed(2);
                // format numeric with thousand separator
                final formattedBalance = NumberFormat.decimalPattern()
                    .format(double.parse(balance.split('.')[0]));
                return GestureDetector(
                  onTap: () {
                    ref
                        .read(userPreferenceProvider.notifier)
                        .switchObscureBalance();
                  },
                  child: RichText(
                    text: TextSpan(
                      text: isObscureBalance
                          ? getObscureString(3)
                          : formattedBalance,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                      children: [
                        TextSpan(
                          text: isObscureBalance
                              ? getObscureString(2)
                              : balance.split('.').length > 1
                                  ? '.${balance.split('.')[1]}'
                                  : '.00',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                  ),
                        ),
                        TextSpan(
                          text: ' USDC',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () {
                return const SizedBox(
                  width: 32.0,
                  height: 64.0,
                  child: JumpingDotIndicator(
                    duration: Duration(milliseconds: 300),
                  ),
                );
              },
              error: (error, _) => Text('Error: $error'),
            ),
          ],
        ),
        // Gaps.h8,
        aaveApy.when(
          data: (value) {
            return Text(
              'Saving APY: ${(value * 100).toStringAsFixed(2)}%',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
            );
          },
          loading: () {
            return const SizedBox(
              width: 32.0,
              height: 28.0,
              child: JumpingDotIndicator(
                duration: Duration(milliseconds: 300),
              ),
            );
          },
          error: (error, _) => Text('Error: $error'),
        ),
        Gaps.h8,
        userProfit.when(
            data: (profit) => Text.rich(
                  TextSpan(
                    text: '🥷 Total Profit: ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    children: [
                      TextSpan(
                        text: profit.toStringAsFixed(3),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                      ),
                      TextSpan(
                        text: ' USDC',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                ),
            loading: () => const SizedBox(
                  width: 32.0,
                  height: 32.0,
                  child: JumpingDotIndicator(
                    duration: Duration(milliseconds: 300),
                  ),
                ),
            error: (e, s) => const SizedBox.shrink()),
      ],
    );
  }
}

String getObscureString(int length) {
  return '\u2217' * length;
}
