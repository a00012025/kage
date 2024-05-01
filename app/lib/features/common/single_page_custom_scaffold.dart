import 'package:app/extension/context_extension.dart';
import 'package:app/features/common/custom_scaffold.dart';
import 'package:app/utils/gaps.dart';
import 'package:flutter/material.dart';

class SinglePageCustomScaffold extends StatelessWidget {
  const SinglePageCustomScaffold({
    Key? key,
    required this.body,
    this.useScrollView = false,
    this.padding,
    this.backgroundColor,
    this.customBottomPadding,
    this.viewInsetBottomPadding = false,
    this.canPop = true,
    this.popValue,
    this.isModalStyle = false,
    this.height,
    this.resizeToAvoidBottomInset,
  }) : super(key: key);
  final Widget body;
  final bool useScrollView;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final double? customBottomPadding;
  final bool viewInsetBottomPadding;
  final bool canPop;
  final dynamic popValue;
  final bool isModalStyle;
  final double? height;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final pageHeight = context.height - context.paddingTop;
    return WillPopScope(
      onWillPop: canPop
          ? null
          : () async {
              return popValue ?? false;
            },
      child: isModalStyle
          ? Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: resizeToAvoidBottomInset,
              body: Column(
                children: [
                  Flexible(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: height ?? context.height * 0.9,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              width: 60,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE0E0E0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                            ),
                            Expanded(child: body),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : CustomScaffold(
              ignoreBottom: true,
              resizeToAvoidBottomInset: useScrollView,
              backgroundColor: Theme.of(context).primaryColor,
              useScrollView: useScrollView,
              body: SizedBox(
                height: pageHeight,
                child: Column(
                  children: [
                    Gaps.h12,
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: backgroundColor ??
                                Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24.0),
                              topRight: Radius.circular(24.0),
                            )),
                        padding: padding ??
                            EdgeInsets.fromLTRB(
                              24,
                              24,
                              24,
                              (customBottomPadding ?? 24) +
                                  context.paddingBottom +
                                  (viewInsetBottomPadding
                                      ? context.viewInsetBottom
                                      : 0),
                            ),
                        child: body,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
