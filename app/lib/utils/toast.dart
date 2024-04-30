import 'package:app/utils/default_button.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

void customToast(String text, {bool showIcon = true}) {
  showToastWidget(
    SizedBox(
      width: 250,
      child: DefaultButton(
        onPressed: () {},
        text: text,
        showIcon: showIcon,
      ),
    ),
    position: ToastPosition.bottom,
  );
}
