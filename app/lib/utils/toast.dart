import 'package:app/utils/default_button.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

void customToast(String text) {
  showToastWidget(
    SizedBox(
      width: 250,
      child: DefaultButton(
        onPressed: () {},
        text: text,
        showIcon: true,
      ),
    ),
    position: ToastPosition.bottom,
  );
}
