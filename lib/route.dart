import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:lasitrade/mouse_handler.dart';
import 'package:lasitrade/widgets/popup_wrapper.dart';
import 'package:lasitrade/screens/search/search_popup.dart';
import 'package:lasitrade/screens/root/login_screen.dart';
import 'package:lasitrade/context.dart';
import 'package:lasitrade/theme.dart';
import 'package:lasitrade/screens/root/splash_screen.dart';
import 'package:lasitrade/screens/root/root_screen.dart';

typedef AppRouteArgs = Map<String, dynamic>;
typedef AppSheetRouteFn = Widget? Function(String name, AppRouteArgs? args);

class AppPopupAction {
  AppPopupAction(
    this.text,
    this.func, {
    this.color,
    this.selected = false,
  });

  final String text;
  final Future<dynamic> Function() func;
  final Color? color;
  final bool selected;
}

abstract class AppRoute {
  static const String srSplash = '/splash';
  static const String srRoot = '/root';
  static const String srLogin = '/login';

  static const String ppSearch = '/search';

  static late List<SingleChildWidget> providers;
  static late Function appNav;

  static OverlayPopoverEntry? currPopupEntry;

  static String? currSheet;
  static String? currPopup;

  static RouteFactory mainRoutes = (RouteSettings settings) {
    // ignore: unused_local_variable
    AppRouteArgs args = settings.arguments as AppRouteArgs? ?? {};

    switch (settings.name) {
      case srSplash:
        return AppRoute.fadeTo(const SplashScreen());
      case srRoot:
        return AppRoute.fadeTo(const RootScreen());
      case srLogin:
        return AppRoute.fadeTo(const LoginScreen());

      default:
        return AppRoute.fadeTo(const RootScreen());
    }
  };

  static Widget? Function(String name, AppRouteArgs args) sheetRoutes = (
    String name, [
    AppRouteArgs args = const {},
  ]) {
    switch (name) {
      // case shSettings:
      //   return const SettingsScreen();
      // case shReport:
      //   return const ReportScreen();
      // case shWatchlist:
      //   return const WatchlistManageScreen();
      // case shMessages:
      //   return const MessagesScreen();

      default:
        return null;
    }
  };

  static Widget? Function(String name, AppRouteArgs args) popupRoutes = (
    String name, [
    AppRouteArgs args = const {},
  ]) {
    switch (name) {
      case ppSearch:
        return const SearchPopup();

      default:
        return null;
    }
  };

  // INTF

  static Future goTo(String name, {AppRouteArgs? args}) async {
    return await AppRoute.appNav().pushNamed(name, arguments: args);
  }

  static Future<void> goBack([dynamic val]) async {
    await AppRoute.appNav().maybePop(val);
  }

  static Future goSheetTo(
    String name, {
    required OverlayPosition position,
    AppRouteArgs args = const {},
  }) async {
    final Widget? widget = sheetRoutes(name, args);
    if (widget == null) return null;

    currSheet = name;

    final res = await openSheet(
      context: appContext,
      builder: (context) => AppMouseHandler(child: widget),
      position: position,
    );

    currSheet = null;

    return res;
  }

  static Future<dynamic> goSheetBack([dynamic val]) async {
    if (currSheet == null) return;
    currSheet = null;

    return await Navigator.maybePop(appContext);
  }

  static Future goPopupTo(
    String name, {
    BuildContext? context,
    AppRouteArgs args = const {},
    Alignment? alignment,
    Offset? offset,
    bool isModal = false,
  }) async {
    final Widget? widget = popupRoutes(name, args);
    if (widget == null) return null;

    if (currPopup != null) goPopupBack();

    currPopup = name;

    currPopupEntry = showPopover(
      context: context ?? appContext,
      alignment: alignment ?? Alignment.topCenter,
      offset: offset ?? Offset(0, 0),
      builder: (context) => AppMouseHandler(
        child: Builder(builder: (context) {
          Widget w = AppPopupWrapper(child: widget);

          if (isModal) {
            w = ModalContainer(child: w);
          }

          return w;
        }),
      ),
    ) as OverlayPopoverEntry?;
  }

  static void goPopupBack([dynamic val]) {
    currPopup = null;

    currPopupEntry?.remove();
    currPopupEntry?.dispose();
    currPopupEntry = null;
  }

  // ETC

  static PageRouteBuilder fadeTo(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (c, a1, a2) => MultiProvider(
        providers: AppRoute.providers,
        child: MediaQuery(
          data: AppTheme.mediaQuery(c),
          child: widget,
        ),
      ),
      transitionsBuilder: (c, anim, a2, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
