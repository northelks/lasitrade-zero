import 'package:flutter/material.dart';

import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/theme.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        color: AppTheme.clText08,
        strokeWidth: 1.5,
      ),
    );
  }
}

class AppProgressIndicatorCenter extends StatelessWidget {
  final double? percent;

  const AppProgressIndicatorCenter({
    super.key,
    this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: context.height,
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppProgressIndicator(),
            if (percent != null) ...[
              10.h,
              Text(
                '${percent!.toStringAsFixed(1)} %',
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}

class AppProgressIndicatoEmpty extends StatelessWidget {
  const AppProgressIndicatoEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: context.height,
      color: AppTheme.clTransparent,
    );
  }
}
