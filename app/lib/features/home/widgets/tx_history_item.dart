import 'package:app/features/home/domain/tx_data.dart';
import 'package:app/utils/app_tap.dart';
import 'package:app/utils/gaps.dart';
import 'package:app/utils/string_utils.dart';
import 'package:app/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TxHistoryItem extends StatelessWidget {
  TxHistoryItem({
    super.key,
    required this.value,
  });

  final TxData value;

  final emojis = [
    '🥷',
    '👨‍🚀',
    '👨‍🚒',
    '👨‍🎨',
    '👨‍🎤',
    '👨‍🏫',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: AppTap(
        onTap: () {
          Clipboard.setData(
            ClipboardData(
              text: value.counterParty,
            ),
          );
          customToast(
            'Copied to clipboard!',
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  emojis[value.counterParty.hashCode % emojis.length],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 24,
                      ),
                ),
              ),
              Gaps.w16,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value.balanceChange > 0 ? 'Received' : 'Sent',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    value.counterParty.toFormattedAddress(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      value.balanceChange.toStringAsFixed(2),
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.w4,
                    Image.asset('assets/icons/usdc.png', width: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
