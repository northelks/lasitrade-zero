import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/route.dart';
import 'package:lasitrade/theme.dart';
import 'package:lasitrade/widgets/buttons/gesture_button.dart';
import 'package:lasitrade/widgets/progress_indicator.dart';

class AppSimpleScaffold extends StatelessWidget {
  const AppSimpleScaffold({
    super.key,
    this.child,
    this.children,
    this.title,
    this.loading = false,
    this.loadingT = false,
    this.loadingTop = false,
    this.loadingBottom = false,
    this.loadingExt = false,
    this.actions,
    this.hideBack = false,
    this.onBack,
    this.onTapTitle,
    this.physics,
    this.wBottom,
    this.scrollCtrl,
    this.padding,
    this.onRefresh,
    this.onLoadMore,
    this.loadMoreAnimate = false,
  });

  final Widget? child;
  final List<Widget>? children;
  final String? title;
  final List<Widget>? actions;
  final bool loading;
  final bool loadingT;
  final bool loadingTop;
  final bool loadingBottom;
  final bool loadingExt;
  final bool hideBack;
  final Future<void> Function()? onBack;
  final VoidCallback? onTapTitle;
  final ScrollPhysics? physics;
  final Widget? wBottom;
  final ScrollController? scrollCtrl;
  final EdgeInsets? padding;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final bool loadMoreAnimate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: key,
        backgroundColor: AppTheme.clBackground,
        resizeToAvoidBottomInset: false,
        appBar: title != null
            ? AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                scrolledUnderElevation: 0,
                backgroundColor: AppTheme.clBackground,
                toolbarHeight: AppTheme.appTitleHeight,
                shadowColor: AppTheme.clBackground,
                foregroundColor: AppTheme.clBackground,
                surfaceTintColor: AppTheme.clBackground,
                leading: hideBack
                    ? null
                    : AppGestureButton(
                        onTry: onBack ?? AppRoute.goBack,
                        child: const Icon(
                          Icons.close_rounded,
                          size: 30,
                          color: AppTheme.clText,
                        ),
                      ),
                actions: [
                  ...?actions,
                  6.w,
                ],
                titleSpacing: 0,
                centerTitle: false,
                title: Container(
                  padding: EdgeInsets.only(left: hideBack ? 16 : 6),
                  child: GestureDetector(
                    onTap: onTapTitle,
                    child: Row(
                      children: [
                        Text(
                          title!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (onTapTitle != null) ...[
                          2.w,
                          Container(
                            padding: const EdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: AppTheme.clYellow,
                              size: 20,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              )
            : null,
        body: Stack(
          children: [
            SizedBox(
              width: context.width,
              height: context.height,
              child: Container(
                padding: EdgeInsets.only(bottom: context.keyboardHeight),
                child: Column(
                  children: [
                    Container(
                        height: 1.5,
                        color: loadingT ? AppTheme.clYellow : AppTheme.clBlack),
                    Expanded(
                      child: Container(
                        color: AppTheme.clBackground,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            SingleChildScrollView(
                              physics: physics ?? const ClampingScrollPhysics(),
                              controller: scrollCtrl,
                              child: Container(
                                padding: padding,
                                child: Column(
                                  children: [
                                    if (physics == null ||
                                        physics is ClampingScrollPhysics)
                                      0.hrr(height: 1.5),
                                    if (child != null) child! else ...?children,
                                    if (hideBack)
                                      (AppTheme.appNavHeight).h
                                    else if (physics == null ||
                                        physics is ClampingScrollPhysics)
                                      (context.notch + 10).h
                                    else
                                      (AppTheme.appNavHeight).h
                                  ],
                                ),
                              ),
                            ),
                            if (physics is AlwaysScrollableScrollPhysics)
                              Container(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    0.hrr(height: 1.5),
                                    if (hideBack) (AppTheme.appNavHeight).h,
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                    if (wBottom != null) ...[
                      wBottom!,
                      if (hideBack) (AppTheme.appNavHeight).h,
                      (context.notch + 10).h,
                    ],
                  ],
                ),
              ),
            ),
            if (loading) const AppProgressIndicatorCenter(),
            if (loadingTop || loadingBottom) const AppProgressIndicatoEmpty(),
            if (loadingExt)
              Container(
                width: context.width,
                height: context.height,
                color: AppTheme.clBackground09,
                child: Center(
                  child: Image.asset(
                    'assets/images/app_icon_tr.png',
                    width: 100,
                    height: 100,
                    cacheHeight: 100,
                    cacheWidth: 100,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
