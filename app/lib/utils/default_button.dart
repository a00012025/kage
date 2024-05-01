import 'package:app/utils/app_tap.dart';
import 'package:app/utils/gaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key,
    required this.onPressed,
    this.text = '',
    this.textStyle,
    this.isDisable = false,
    this.showIcon = false,
    this.child,
    this.shimmer = true,
    this.backgroundColor,
    this.borderColor,
  });
  final VoidCallback onPressed;
  final String text;
  final TextStyle? textStyle;
  final bool isDisable;
  final bool showIcon;
  final Widget? child;
  final bool shimmer;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return AppTap(
      onTap: isDisable ? () {} : onPressed,
      child: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color:
                  backgroundColor ?? (isDisable ? Colors.grey : Colors.black),
              borderRadius: BorderRadius.circular(Spacings.px12),
              border: Border.all(
                color: borderColor ?? (isDisable ? Colors.grey : Colors.black),
                width: 1,
              ),
            ),
            child: child ??
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(Spacings.px12),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: textStyle ??
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                ),
          )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: false),
              )
              .shimmer(
                  duration: shimmer ? 1.3.seconds : 0.seconds,
                  delay: 3.seconds),
          if (showIcon)
            Positioned(
              top: 12,
              left: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: Spacings.px8),
                child: Image.asset(
                  'assets/icons/ninja_white.png',
                  width: 24,
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .flipH(duration: 300.ms),
              ),
            ),
        ],
      ),
    );
  }
}
