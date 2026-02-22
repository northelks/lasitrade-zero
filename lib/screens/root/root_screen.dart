import 'dart:async';

import 'package:lasitrade/viewmodels/instrument_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:lasitrade/constants.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/screens/charts/chart_screen.dart';
import 'package:lasitrade/screens/infoprices/watchlist_manage_screen.dart';
import 'package:lasitrade/screens/messages/messages_screen.dart';
import 'package:lasitrade/screens/reports/report_screen.dart';
import 'package:lasitrade/screens/settings/settings_screen.dart';
import 'package:lasitrade/widgets/empty.dart';
import 'package:lasitrade/mouse_handler.dart';
import 'package:lasitrade/context.dart';
import 'package:lasitrade/screens/root/widgets/root_left.dart';
import 'package:lasitrade/screens/tradelist/tradelist_screen.dart';
import 'package:lasitrade/screens/infoprices/watchlist_screen.dart';
import 'package:lasitrade/viewmodels/app_viewmodel.dart';
import 'package:lasitrade/window.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/theme.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with WidgetsBindingObserver {
  bool _init = true;

  @override
  void initState() {
    super.initState();

    appContext = context;

    scheduleMicrotask(() async {
      await setupWinRoot();
      await Future.delayed(100.mlsec);

      //! refactor
      // await rtServ.connect();
      // final uicsAll = instVM.instruments.map((e) => e.uic).toList();
      // for (var it in uicsAll) {
      //   await rtServ.subscribeToChart(uic: 211, horizon: 1);
      //   await Future.delayed(const Duration(milliseconds: 250));
      // }
      // await rtServ.subscribeToInfoPrices(
      //     uics: uicsAll.take(200).toList(), accountKey: appVM.accountKey);

      setState(() {
        _init = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    context.watch<AppViewModel>();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_init) return Container(color: AppTheme.clBackground);

    Widget leftScreen = AppEmpty();
    if (appVM.tab == cstTabs['home']) {
      leftScreen = WatchlistScreenExt();
    } else if (appVM.tab == cstTabs['reports']) {
      leftScreen = ReportScreen();
    } else if (appVM.tab == cstTabs['watchlists']) {
      leftScreen = WatchlistManageScreen();
    } else if (appVM.tab == cstTabs['messages']) {
      leftScreen = MessagesScreen();
    } else if (appVM.tab == cstTabs['settings']) {
      leftScreen = SettingsScreen();
    }

    return DrawerOverlay(
      child: AppMouseHandler(
        child: Container(
          width: context.width,
          height: context.height,
          color: AppTheme.clBackground,
          child: Row(
            children: [
              SizedBox(
                height: context.height,
                width: 40,
                child: RootLeft(),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 25,
                            child: leftScreen,
                          ),
                          Expanded(
                            flex: 72,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      right: 4,
                                      left: 4,
                                      top: 0,
                                      bottom: 2,
                                    ),
                                    child: Builder(builder: (context) {
                                      context.watch<InstrumentViewModel>();

                                      return Row(
                                        children: [
                                          Expanded(
                                            child: ChartScreen(
                                              isD1: false,
                                              inx: 0,
                                              isTp: true,
                                            ),
                                          ),
                                          Expanded(
                                            child: ChartScreen(
                                              isD1: true,
                                              inx: 0,
                                              isTp: true,
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      right: 4,
                                      left: 4,
                                      top: 0,
                                      bottom: 2,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ChartScreen(
                                            isD1: false,
                                            inx: 0,
                                            isTp: false,
                                          ),
                                        ),
                                        Expanded(
                                          child: ChartScreen(
                                            isD1: false,
                                            inx: 1,
                                            isTp: false,
                                          ),
                                        ),
                                        Expanded(
                                          child: ChartScreen(
                                            isD1: false,
                                            inx: 2,
                                            isTp: false,
                                          ),
                                        ),
                                        Expanded(
                                          child: ChartScreen(
                                            isD1: false,
                                            inx: 3,
                                            isTp: false,
                                          ),
                                        ),
                                        Expanded(
                                          child: ChartScreen(
                                            isD1: false,
                                            inx: 4,
                                            isTp: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 94,
                                  width: context.width,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      top: 2,
                                      bottom: 2,
                                    ),
                                    child: TradeListScreen(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
