import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  double get paddingBottom => MediaQuery.of(this).padding.bottom;
  double get paddingTop => MediaQuery.of(this).padding.top;
  double get viewInsetBottom => MediaQuery.of(this).viewInsets.bottom;
  double get textScaleFactor => MediaQuery.of(this).textScaleFactor;
}
