import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KgAppBar extends StatelessWidget {
  const KgAppBar({
    Key? key,
    this.child,
    this.height = 0.0,
    this.backgroundColor = Colors.white,
    this.customNavigationBarColor,
  }) : super(key: key);

  final double height;
  final Color backgroundColor;
  final Color? customNavigationBarColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final overlayStyle =
        ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: customNavigationBarColor ?? Colors.white,
      ),
      sized: false,
      child: Container(
        color: backgroundColor,
        child: child,
      ),
    );
  }
}
