import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' hide Colors;

import 'package:lasitrade/utils/core_utils.dart';
import 'package:lasitrade/models/trade_model.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/theme.dart';
import 'package:lasitrade/widgets/buttons/mouse_button.dart';
import 'package:lasitrade/widgets/buttons/simple_button.dart';

class TradeItem extends StatefulWidget {
  final TradeModel trade;

  const TradeItem({
    super.key,
    required this.trade,
  });

  @override
  State<TradeItem> createState() => _TradeItemState();
}

class _TradeItemState extends State<TradeItem> {
  late final PopoverController _ctrlPopover;

  @override
  void initState() {
    _ctrlPopover = PopoverController();

    tradeVM.ctrlTradePopovers.add(_ctrlPopover);

    super.initState();
  }

  @override
  void dispose() {
    tradeVM.ctrlTradePopovers.remove(_ctrlPopover);

    _ctrlPopover.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPreOrder =
        widget.trade.order == null && widget.trade.position == null;
    final isOrder = widget.trade.order != null;
    final isPosition = widget.trade.position != null;

    //~

    final inst = instVM.instrumentOf(widget.trade.uic);
    if (inst == null) return const SizedBox.shrink();

    final infoPrice = infoPriceVM.infoPriceOf(widget.trade.uic);
    final rlOrder = tradeVM.orderOf(widget.trade.uic);

    final lastTraded = double.parse(
      (infoPrice?.lastTraded ?? 0.0).toStringAsFixed(2),
    );

    final cashRequired = lastTraded * widget.trade.amount + 2;
    final hasCash = tradeVM.balance.cashAvailableForTrading >= cashRequired;

    //~

    Color itemBorderColor = Colors.black;
    double total = 0.0;
    double plNet = 0.0;
    double plPerc = 0.0;

    VoidCallback? doFn;

    if (isPreOrder) {
      itemBorderColor = hasCash ? Colors.black : Colors.brown;
      total = cashRequired;

      if (widget.trade.amount == 0) {
        total = -0.0;
      }

      doFn = () {
        tradeVM.pushTrade(
          trade: widget.trade,
          lastTraded: lastTraded,
        );
      };

      tradeVM.doPushTrade = doFn;
    } else if (isOrder) {
      itemBorderColor = AppTheme.clWhite.withOpacity(0.7);

      doFn = () {
        tradeVM.cancelTrade(
          trade: widget.trade,
        );
      };

      tradeVM.doPushTrade = null;
    } else if (isPosition) {
      total = (lastTraded - widget.trade.op) * widget.trade.amount - 2;
      plNet = lastTraded - widget.trade.op;
      plPerc = (lastTraded - widget.trade.op) / widget.trade.op * 100;

      itemBorderColor = fnGetNumColor(total);

      doFn = () async {
        if (rlOrder != null) {
          await tradeServ.modifyOrder(
            rlOrder: rlOrder,
            orderPrice: lastTraded,
          );

          await tradeVM.syncMessages();
        }
      };

      tradeVM.doPushTrade = null;
    }

    return AppMouseButton(
      onTap: () => instVM.setInstrumentBySymbol(inst.symbol),
      onRightClick: () {
        String? text;
        Color? textColor;
        Color? borderColor;

        if (isPreOrder) {
          if (!hasCash) return;

          text = 'Open';
          textColor = Colors.white;
          borderColor = Colors.white;
        } else if (isOrder) {
          text = 'Cancel';
          textColor = AppTheme.clWhite.withOpacity(0.7);
          borderColor = AppTheme.clWhite.withOpacity(0.7);
        } else if (isPosition) {
          text = 'Execute';
          textColor = fnGetNumColor(total);
          borderColor = fnGetNumColor(total);
        }

        if (text == null) return;

        _ctrlPopover.show(
          context: context,
          builder: (context) {
            return SizedBox(
              width: 245,
              child: AppSimpleButton(
                text: text,
                textColor: textColor,
                borderColor: borderColor,
                onTap: () async {
                  _ctrlPopover.close();

                  doFn?.call();
                },
              ),
            );
          },
          alignment: AlignmentGeometry.topCenter,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            width: 2,
            color: itemBorderColor,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 14,
                    top: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        inst.symbol,
                        style: TextStyle(
                          fontSize: inst.symbol.endsWith('_NEW') ? 16 : 21,
                          color: AppTheme.clWhite,
                          letterSpacing: 1.4,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          bottom: 0,
                          left: 3,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'x',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.clText04,
                              ),
                            ),
                            1.w,
                            Container(
                              padding: const EdgeInsets.only(top: 1),
                              child: Text(
                                widget.trade.amount.toStringAsFixed(0),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.clText04,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    right: 10,
                    left: 10,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          right: 5,
                          top: 5,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (isPreOrder) ...[
                              Text(
                                total.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 19,
                                  color: hasCash ? Colors.white : Colors.brown,
                                ),
                              ),
                              1.w,
                              Text(
                                '\$',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: hasCash ? Colors.white : Colors.brown,
                                ),
                              ),
                            ] else if (isPosition) ...[
                              Text(
                                total.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 19,
                                  color: itemBorderColor,
                                ),
                              ),
                              1.w,
                              Text(
                                '\$',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: itemBorderColor,
                                ),
                              ),
                            ] else if (isOrder) ...[
                              Text(
                                '',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.brown,
                                ),
                              ),
                              1.w,
                              Text(
                                '[ ${DateFormat('d MMM, HH:mm').format(widget.trade.order!.orderTime)} ]',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.brown,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (isPosition) ...[
                        8.w,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 2),
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      plPerc.toStringAsFixed(2),
                                      style: TextStyle(
                                        color: itemBorderColor,
                                        fontSize: 10,
                                      ),
                                    ).xSmall,
                                  ),
                                  1.w,
                                  Container(
                                    padding: const EdgeInsets.only(
                                      bottom: 6,
                                    ),
                                    child: Text(
                                      '%',
                                      style: TextStyle(
                                        color: itemBorderColor,
                                        fontSize: 8,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            1.h,
                            Container(
                              padding: const EdgeInsets.only(),
                              child: Text(
                                plNet.toStringAsFixed(2),
                                style: TextStyle(
                                  color: itemBorderColor,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ],
                  ),
                ),
              ],
            ),
            7.h,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        lastTraded.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.clText09,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          bottom: 14,
                          left: 2,
                        ),
                        child: Text(
                          'cr',
                          style: TextStyle(
                            fontSize: 8,
                            color: AppTheme.clYellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  20.w,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.trade.op.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.clText09,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          bottom: 14,
                          left: 2,
                        ),
                        child: Text(
                          'op',
                          style: TextStyle(
                            fontSize: 7,
                            color: Colors.cyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                        child: Text(
                          '•',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Text(
                        widget.trade.sl.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.clText09,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          bottom: 14,
                          left: 2,
                        ),
                        child: Text(
                          'sl',
                          style: TextStyle(
                            fontSize: 7,
                            color: AppTheme.clRed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
