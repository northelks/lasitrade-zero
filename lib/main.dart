import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:lasitrade/constants.dart';
import 'package:lasitrade/tray.dart';
import 'package:lasitrade/shadcn.dart';
import 'package:lasitrade/hotkeys.dart';
import 'package:lasitrade/utils/core_utils.dart';
import 'package:lasitrade/window.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/route.dart';
import 'package:lasitrade/theme.dart';
import 'package:lasitrade/screens/root/splash_screen.dart';

void main() async {
  SentryWidgetsFlutterBinding.ensureInitialized();

  await setupGetIt();
  await crashServ.init();

  await setupWinRoot();
  await setupHotKeys();

  // await appTray.init();
  await appDoteEnv.load();

  await crashServ.runApp(
    app: const MyApp(),
    sentryDSN: cstSentryDSN,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    AppRoute.providers = [
      ChangeNotifierProvider(create: (_) => appVM),
      ChangeNotifierProvider(create: (_) => instVM),
      ChangeNotifierProvider(create: (_) => infoPriceVM),
      ChangeNotifierProvider(create: (_) => reportVM),
      ChangeNotifierProvider(create: (_) => searchVM),
      ChangeNotifierProvider(create: (_) => tradeVM),
      ChangeNotifierProvider(create: (_) => histVM),
    ];

    AppRoute.appNav = () => _navigatorKey.currentState as NavigatorState;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugInvertOversizedImages = false;

    return MultiProvider(
      providers: AppRoute.providers,
      child: ShadcnApp(
        key: GlobalKey(),
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.get(),
        onGenerateRoute: AppRoute.mainRoutes,
        home: const SplashScreen(),
      ),
    );
  }
}
