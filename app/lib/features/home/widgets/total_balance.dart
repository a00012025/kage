import 'package:app/features/home/controllers/aave_data_controller.dart';
import 'package:app/features/home/controllers/user_balance_controller.dart';
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
    final aaveApy = ref.watch(aaveDataProvider);

    return Column(
      children: [
        Text(
          '🥷 Total Balance',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Gaps.h12,
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
                return RichText(
                  text: TextSpan(
                    text: balance.split('.')[0],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                    children: [
                      TextSpan(
                        text: balance.split('.').length > 1
                            ? '.${balance.split('.')[1]}'
                            : '.00',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                      ),
                      TextSpan(
                        text: 'USDC',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                );
              },
              loading: () {
                return const SizedBox(
                  width: 32.0,
                  height: 52.0,
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
              height: 32.0,
              child: JumpingDotIndicator(
                duration: Duration(milliseconds: 300),
              ),
            );
          },
          error: (error, _) => Text('Error: $error'),
        ),
      ],
    );
  }
}
