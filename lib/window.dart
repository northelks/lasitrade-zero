import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

// Future<void> setupWinSplash() async {
//   await windowManager.ensureInitialized();

//   await windowManager.setTitle('lasitrade');
//   await windowManager.setAlignment(Alignment.center);
//   // await windowManager.setAsFrameless();
//   await windowManager.setSize(Size(400, 400));
// }

Future<void> setupWinLogin() async {
  await windowManager.ensureInitialized();

  await windowManager.setTitle('lasitrade');
  await windowManager.setTitleBarStyle(TitleBarStyle.normal);

  await windowManager.setSize(Size(500, 800));
  await windowManager.setAlignment(Alignment.center);
}

Future<void> setupWinRoot() async {
  await windowManager.ensureInitialized();

  await windowManager.setTitle('lasitrade');
  await windowManager.setTitleBarStyle(TitleBarStyle.normal);

  await windowManager.setMaximizable(true);
  await windowManager.maximize();
}
