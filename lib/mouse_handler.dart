import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AppMouseHandlerStatus {
  static bool isRightBtn = false;
}

class AppMouseHandler extends StatelessWidget {
  final Widget child;

  const AppMouseHandler({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (PointerDownEvent event) {
        if (event.kind == PointerDeviceKind.mouse) {
          if (event.buttons == kSecondaryMouseButton) {
            AppMouseHandlerStatus.isRightBtn = true;
          } else if (event.buttons == kPrimaryMouseButton) {
            if (AppMouseHandlerStatus.isRightBtn) {
              AppMouseHandlerStatus.isRightBtn = false;
            }
          }
        }
      },
      child: child,
    );
  }
}
