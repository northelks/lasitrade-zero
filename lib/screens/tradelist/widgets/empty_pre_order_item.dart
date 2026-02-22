import 'package:flutter/material.dart';
import 'package:lasitrade/theme.dart';

class EmptyPreOrderItem extends StatelessWidget {
  const EmptyPreOrderItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          width: 2,
          color: AppTheme.clBlack,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(),
    );
  }
}
