import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/theme.dart';
import 'package:lasitrade/viewmodels/trade_viewmodel.dart';
import 'package:lasitrade/widgets/buttons/gesture_button.dart';
import 'package:lasitrade/widgets/buttons/mouse_button.dart';
import 'package:provider/provider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void didChangeDependencies() {
    context.watch<TradeViewModel>();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          10.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              40.w,
              Text(
                'Messages',
                style: TextStyle(
                  fontSize: 19,
                  letterSpacing: 0.4,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 15),
                child: AppMouseButton(
                  onTap: () async {
                    if (!tradeVM.hasUnseen) return;

                    await tradeVM.markAllAsSeenMessages();
                    tradeVM.notify();

                    appVM.notify();
                  },
                  child: Icon(
                    Icons.mark_as_unread_outlined,
                    size: 20,
                    color: tradeVM.hasUnseen
                        ? AppTheme.clYellow
                        : AppTheme.clText04,
                  ),
                ),
              ),
            ],
          ),
          10.hrr(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (var msg in tradeVM.messages)
                    Builder(builder: (context) {
                      String body = msg.messageBody;

                      body = body.replaceAll(
                          '  Extended hours: On.', '\nExtended hours: On.');
                      body = body.replaceAll('Account: 800401INET', '');
                      body = body.replaceAll(
                          'Front office position id', 'Position id');
                      body =
                          body.replaceAll('Front office order id', 'Order id');

                      return AppGestureButton(
                        onTap: () async {
                          // String? data;

                          // if (msg.orderId != null) {
                          //   final order = tradeVM.orders.firstWhereOrNull(
                          //     (it) => it.orderId == msg.orderId,
                          //   );
                          //   if (order == null) {
                          //     final clposit = reportVM.rClosedPositions.where((it) => it.)
                          //   }
                          // }

                          // await fnShowInfoDialog(
                          //   title: 'JSON',
                          //   text: prettyPrintJson(data),
                          // );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                bottom: 5,
                                left: 20,
                                right: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    msg.messageHeader,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.clYellow,
                                    ),
                                  ),
                                  Builder(builder: (context) {
                                    String text =
                                        DateFormat('d MMM yyyy, HH:mm:ss')
                                            .format(msg.dateTime);

                                    return Text(
                                      text,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.clText07,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            Container(
                              width: context.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: !msg.seen
                                    ? AppTheme.clYellow01
                                    : AppTheme.clText005,
                              ),
                              margin: const EdgeInsets.only(
                                bottom: 20,
                                left: 15,
                                right: 15,
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    body.trim(),
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (msg.sourceOrderId != null)
                                    Text(
                                      'Source order id: ${msg.sourceOrderId}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
