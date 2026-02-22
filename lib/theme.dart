import 'package:flutter/material.dart';

import 'package:lasitrade/shadcn.dart';

abstract class AppTheme {
  //+ colors palette

  static const Color clBlack = Color.fromARGB(255, 0, 0, 0);
  static const Color clBlack02 = Color.fromARGB(51, 0, 0, 0);

  static const Color clTransparent = Colors.transparent;

  static const Color clWhite = Colors.white;

  static const Color clYellow = Color.fromARGB(255, 245, 210, 51);
  static const Color clYellow005 = Color.fromARGB(13, 245, 210, 51);
  static const Color clYellow008 = Color.fromARGB(19, 245, 210, 51);
  static const Color clYellow01 = Color.fromARGB(26, 245, 210, 51);
  static const Color clYellow02 = Color.fromARGB(51, 245, 210, 51);
  static const Color clYellow03 = Color.fromARGB(77, 245, 210, 51);
  static const Color clYellow05 = Color.fromARGB(128, 245, 210, 51);
  static const Color clYellow07 = Color.fromARGB(179, 245, 210, 51);
  static const Color clYellow08 = Color.fromARGB(204, 245, 210, 51);

  static const Color clYellowSelected = AppTheme.clYellow008;

  static const Color clOrange = Colors.orange;

  static const Color clGreen = Colors.green;

  // static final Color clGrey900 = Colors.grey[900]!;
  static const Color clGrey27 = Color(0xff272727);

  static const Color clBlue = Color.fromARGB(255, 33, 150, 243);
  static const Color clBlue08 = Color.fromARGB(204, 33, 150, 243);

  static const Color clRed = Colors.red;
  static const Color clRed02 = Color.fromARGB(51, 30, 10, 8);
  static const Color clRed03 = Color.fromARGB(77, 244, 67, 54);
  static const Color clRed04 = Color.fromARGB(102, 244, 67, 54);
  static const Color clRed05 = Color.fromARGB(128, 244, 67, 54);
  static const Color clRed06 = Color.fromARGB(153, 244, 67, 54);
  static const Color clRed08 = Color.fromARGB(204, 244, 67, 54);
  // static final Color clDeepOrange = Colors.deepOrange;

  // --

  static const Color clBackground = Color.fromARGB(255, 22, 20, 21);
  static const Color clBackground04 = Color.fromARGB(102, 22, 20, 21);
  static const Color clBackground05 = Color.fromARGB(128, 22, 20, 21);
  static const Color clBackground09 = Color.fromARGB(230, 22, 20, 21);

  static const Color clText = Color.fromARGB(255, 255, 255, 255);
  static const Color clText002 = Color.fromARGB(5, 255, 255, 255);
  static const Color clText005 = Color.fromARGB(13, 255, 255, 255);
  static const Color clText01 = Color.fromARGB(26, 255, 255, 255);
  static const Color clText02 = Color.fromARGB(51, 255, 255, 255);
  static const Color clText03 = Color.fromARGB(77, 255, 255, 255);
  static const Color clText04 = Color.fromARGB(102, 255, 255, 255);
  static const Color clText05 = Color.fromARGB(128, 255, 255, 255);
  static const Color clText07 = Color.fromARGB(179, 255, 255, 255);
  static const Color clText08 = Color.fromARGB(204, 255, 255, 255);
  static const Color clText09 = Color.fromARGB(230, 255, 255, 255);

  static const Color clText2 = Color(0xFF8E8E93);

  //+ sizes

  static const double appBtnHeight = 35.0;
  static const double appBtnWidth = 0.7;
  static const double appBtnRadius = 4.0;

  static const double appTextFieldHeight = 38.0;

  static const double appLR = 15.0;
  static const double appDL = 15.0;
  static const double appTitleHeight = 45.0;
  static const double appNavHeight = 80.0;

  static const double appOptionHeigth = appBtnHeight;

  static const double appProfileNavHeight = 100.0;

  //+ media

  static MediaQueryData mediaQuery(BuildContext context) {
    return MediaQuery.of(context).copyWith(
      boldText: false,
      highContrast: false,
      invertColors: false,
    );
  }

  static get() {
    return ShadcnThemeData.dark(
      platform: TargetPlatform.macOS,
      radius: 0.5,
    );
  }
}
