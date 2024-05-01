import 'dart:core';

import 'package:app/features/common/kg_app_bar.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  CustomScaffold({
    required this.body,
    this.backgroundColor = Colors.white,
    this.resizeToAvoidBottomInset = true,
    this.hasGoBack = false,
    this.ignoreBottom = false,
    this.title = '',
    this.padding,
    this.useScrollView = false,
    this.trailing,
  });
  final Widget body;
  final bool resizeToAvoidBottomInset;
  final Color backgroundColor;
  final bool hasGoBack;
  final bool ignoreBottom;
  final String? title;
  final EdgeInsets? padding;
  final bool useScrollView;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final leading = hasGoBack
        ? GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.only(top: 15, left: 15),
              child: Icon(Icons.arrow_back, size: 32),
            ),
          )
        : const SizedBox.shrink();
    final header = !hasGoBack && title == '' && trailing == null
        ? const SizedBox.shrink()
        : Row(
            children: [
              Expanded(
                  child: Container(
                      alignment: Alignment.centerLeft, child: leading)),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(title ?? '',
                    style: Theme.of(context).textTheme.displaySmall),
              ),
              Expanded(
                  child: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(top: 15, right: 20),
                      child: trailing ?? const SizedBox.shrink())),
            ],
          );

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      body: KgAppBar(
        backgroundColor: backgroundColor,
        child: SafeArea(
            bottom: !ignoreBottom,
            minimum: padding ?? EdgeInsets.zero,
            child: useScrollView
                ? SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        header,
                        body,
                      ],
                    ))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      header,
                      body,
                    ],
                  )),
      ),
    );
  }
}
