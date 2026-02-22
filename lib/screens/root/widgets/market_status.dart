import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:lasitrade/getit.dart';
import 'package:lasitrade/theme.dart';
import 'package:lasitrade/widgets/buttons/mouse_button.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart'
    show showPopover, ModalContainer;

class MarketStatus extends StatelessWidget {
  const MarketStatus({super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.brown;

    if (!appVM.isFullTradingAndChat) {
      color = Colors.red;
    } else if (appVM.isNasdaqOpen) {
      color = AppTheme.clYellow;
    }

    return AppMouseButton(
      onTap: () async {
        showPopover(
          context: context,
          alignment: Alignment.topCenter,
          builder: (_) => ModalContainer(child: MarketStatusPopover()),
        );
      },
      child: Row(
        children: [
          Icon(
            Icons.electrical_services_rounded,
            color: color,
            // size: BottomScreen.iconSize,
          ),
          // 5.w,
          // Text(
          //   'Open',
          //   style: TextStyle(
          //     fontSize: BottomScreen.fontSize - 1,
          //   ),
          // )
        ],
      ),
    );
  }
}

class MarketStatusPopover extends StatelessWidget {
  const MarketStatusPopover({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (var ses in appVM.nasdaq.exchangeSessions)
            Builder(builder: (context) {
              String state = ses.state;
              if (state == 'AutomatedTrading') {
                state = 'Open';
              }

              bool selected = false;
              if (DateTime.now().isAfter(ses.startTime) &&
                  DateTime.now().isBefore(ses.endTime)) {
                selected = true;
              }

              final df = DateFormat('dd MMM HH:mm');

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state,
                      style: TextStyle(
                        fontSize: 14,
                        color: selected ? AppTheme.clYellow : null,
                      ),
                    ),
                    Text(
                      '${df.format(ses.startTime)} - ${df.format(ses.endTime)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: selected ? AppTheme.clOrange : AppTheme.clText07,
                      ),
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
