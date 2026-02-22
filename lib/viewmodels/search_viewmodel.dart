import 'package:flutter/material.dart';

import 'package:lasitrade/extensions.dart';

class SearchViewModel extends ChangeNotifierExt {
  int searchTab = 0;
  int fWatch = 0;
  int fScreen = 0;

  final FocusNode searchFocusNode = FocusNode();

  bool loading = false;
}
