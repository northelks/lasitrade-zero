import 'package:flutter/material.dart';
import 'package:lasitrade/constants.dart';
import 'package:provider/provider.dart';

import 'package:lasitrade/viewmodels/app_viewmodel.dart';
import 'package:lasitrade/viewmodels/trade_viewmodel.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/shadcn.dart';
import 'package:lasitrade/theme.dart';
import 'package:lasitrade/widgets/buttons/mouse_button.dart';

class RootLeft extends StatefulWidget {
  const RootLeft({super.key});

  @override
  State<RootLeft> createState() => _RootLeftState();
}

class _RootLeftState extends State<RootLeft> {
  @override
  void didChangeDependencies() {
    context.watch<AppViewModel>();
    context.watch<TradeViewModel>();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = 21;
    double dl = 25;

    void onTap(IconData icon) {
      if (appVM.tab != icon) {
        appVM.tab = icon;
        appVM.notify();
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(width: 2, color: Colors.black)),
      ),
      padding: const EdgeInsets.only(top: 12, bottom: 12, left: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          4.h,
          Builder(builder: (context) {
            final icon = cstTabs['home']!;

            return AppMouseButton(
              onTap: () => onTap(icon),
              child: Icon(
                icon,
                size: iconSize,
                color: appVM.tab == icon ? AppTheme.clYellow : null,
              ),
            );
          }),
          dl.h,
          Builder(builder: (context) {
            final icon = cstTabs['reports']!;

            return AppMouseButton(
              onTap: () => onTap(icon),
              child: Icon(
                icon,
                size: iconSize,
                color: appVM.tab == icon ? AppTheme.clYellow : null,
              ),
            );
          }),
          dl.h,
          Builder(builder: (context) {
            final icon = cstTabs['watchlists']!;

            return AppMouseButton(
              onTap: () => onTap(icon),
              child: Icon(
                icon,
                size: iconSize + 1,
                color: appVM.tab == icon ? AppTheme.clYellow : null,
              ),
            );
          }),
          dl.h,
          Builder(builder: (context) {
            final icon = cstTabs['messages']!;
            final icon1 = BootstrapIcons.chatRightTextFill;

            return AppMouseButton(
              onTap: () => onTap(icon),
              child: Icon(
                tradeVM.hasUnseen ? icon1 : icon,
                size: iconSize - 2,
                color: appVM.tab == icon
                    ? AppTheme.clYellow
                    : (tradeVM.hasUnseen ? AppTheme.clOrange : null),
              ),
            );
          }),
          // dl.h,
          // 5.h,
          // (dl - 8).hrr(height: 2),
          // Builder(builder: (context) {
          //   final icon = cstTabs['hists']!;

          //   return AppMouseButton(
          //     onTap: () => onTap(icon),
          //     child: Icon(
          //       icon,
          //       size: iconSize,
          //       color: appVM.tab == icon ? AppTheme.clYellow : null,
          //     ),
          //   );
          // }),
          //
          const Spacer(),
          //
          Builder(builder: (context) {
            final icon = cstTabs['settings']!;

            Color stcolor = Colors.brown;
            if (!appVM.isFullTradingAndChat) {
              stcolor = Colors.red;
            } else if (appVM.isNasdaqOpen) {
              stcolor = AppTheme.clYellow;
            }

            return AppMouseButton(
              onTap: () => onTap(icon),
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: iconSize,
                    color: appVM.tab == icon ? AppTheme.clYellow : null,
                  ),
                  12.h,
                  Icon(
                    Icons.electrical_services_rounded,
                    color: stcolor,
                    size: 14,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
