import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppTap extends StatefulWidget {
  const AppTap({
    required this.onTap,
    required this.child,
    this.hasEffect = true,
    this.onTapUp,
    super.key,
  });

  final VoidCallback onTap;
  final Widget child;
  final bool hasEffect;
  final GestureTapUpCallback? onTapUp;

  @override
  State<AppTap> createState() => _AppTapState();
}

class _AppTapState extends State<AppTap> {
  bool isPressing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => widget.onTap.call(),
      onTapDown: (details) {
        setState(() {
          isPressing = true;
        });
        HapticFeedback.mediumImpact();
      },
      onTapUp: (details) {
        setState(() {
          isPressing = false;
        });
        widget.onTapUp?.call(details);
      },
      onTapCancel: () {
        setState(() {
          isPressing = false;
        });
      },
      child: AnimatedScale(
        scale: (isPressing && widget.hasEffect) ? 0.95 : 1,
        duration: 100.ms,
        child: widget.child,
      ),
    );
  }
}
