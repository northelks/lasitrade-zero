import 'package:flutter/material.dart';
import 'package:lasitrade/theme.dart';

class AppEmpty extends StatelessWidget {
  const AppEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Empty.',
      style: TextStyle(
        fontSize: 13,
        color: AppTheme.clText05,
        letterSpacing: 0.4,
      ),
      textAlign: TextAlign.center,
    );
  }
}
