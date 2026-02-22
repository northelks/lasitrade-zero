import 'package:flutter/material.dart';
import 'package:lasitrade/route.dart';

class AppPopupWrapper extends StatefulWidget {
  final Widget child;

  const AppPopupWrapper({
    super.key,
    required this.child,
  });

  @override
  State<AppPopupWrapper> createState() => _AppPopupWrapperState();
}

class _AppPopupWrapperState extends State<AppPopupWrapper> {
  @override
  void dispose() {
    if (AppRoute.currPopup != null) {
      AppRoute.goPopupBack();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
