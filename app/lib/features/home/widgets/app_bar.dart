import 'package:app/utils/gaps.dart';
import 'package:flutter/material.dart';

class AppBarSmall extends StatelessWidget {
  const AppBarSmall({super.key, required this.balance});

  final double balance;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          const Spacer(),
          Text(
            balance.toStringAsFixed(2),
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
