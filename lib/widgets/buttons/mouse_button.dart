import 'package:flutter/widgets.dart';

import 'package:lasitrade/utils/core_utils.dart';

class AppMouseButton extends StatelessWidget {
  const AppMouseButton({
    super.key,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onRightClick,
    this.onHover,
    this.onTry,
    required this.child,
  });

  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onRightClick;
  final Function(bool value)? onHover;
  final Future<dynamic> Function()? onTry;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHover?.call(true),
      onExit: (_) => onHover?.call(false),
      child: GestureDetector(
        onTap: () async {
          if (onTap != null) {
            onTap!.call();
          } else if (onTry != null) {
            return await fnTry(() async {
              return await onTry!.call();
            });
          }
        },
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        onSecondaryTap: onRightClick,
        child: child,
      ),
    );
  }
}
