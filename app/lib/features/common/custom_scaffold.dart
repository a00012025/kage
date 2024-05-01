import 'dart:core';
import 'package:app/features/common/kg_app_bar.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.body,
    this.backgroundColor = Colors.white,
    this.resizeToAvoidBottomInset = true,
    this.ignoreBottom = false,
    this.title = '',
    this.padding,
    this.useScrollView = false,
  });

  final Widget body;
  final bool resizeToAvoidBottomInset;
  final Color backgroundColor;
  final bool ignoreBottom;
  final String? title;
  final EdgeInsets? padding;
  final bool useScrollView;

  @override
  Widget build(BuildContext context) {
    final header = title == ''
        ? const SizedBox.shrink()
        : Row(
            children: [
              const Expanded(child: SizedBox.shrink()),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(title ?? '',
                    style: Theme.of(context).textTheme.displaySmall),
              ),
              const Expanded(child: SizedBox.shrink()),
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
