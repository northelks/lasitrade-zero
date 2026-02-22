import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
// import 'package:lasitrade/models/msg_position_model.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' show PopoverController;

import 'package:lasitrade/models/trade_model.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/models/db/db_trade_message_model.dart';
import 'package:lasitrade/models/saxo/saxo_balance_model.dart';
import 'package:lasitrade/models/saxo/saxo_order_model.dart';
import 'package:lasitrade/models/saxo/saxo_position_model.dart';

class TradeViewModel extends ChangeNotifierExt {
  late SaxoBalanceModel _balance;
  SaxoBalanceModel get balance => _balance;

  //~

  List<DBTradeMessageModel> _messages = [];
  List<DBTradeMessageModel> get messages => _messages;

  // List<MsgPositionModel> get msgPositions {
  //   List<MsgPositionModel> list = [];

  //   for (var msg in tradeVM.messages) {
  //     try {
  //       final msgpos = MsgPositionModel.fromTradeMessage(msg);
  //       list.add(msgpos);
  //       print(1);
  //     } catch (_) {}
  //   }

  //   return list;
  // }

  bool get hasUnseen =>
      messages.firstWhereOrNull((it) => it.seen == false) != null;

  //~

  List<SaxoPositionModel> _positions = [];
  List<SaxoPositionModel> get positions => _positions;

  SaxoPositionModel? positionOf(int uic) {
    return _positions.firstWhereOrNull((e) => e.uic == uic);
  }

  //~

  List<SaxoOrderModel> _orders = [];
  List<SaxoOrderModel> get orders =>
      _orders.where((it) => !it.isTrailing).toList();

  SaxoOrderModel? orderOf(int uic) {
    return _orders.firstWhereOrNull((e) => e.uic == uic);
  }

  //~

  VoidCallback? doPushTrade;

  //~

  TradeModel? buildPreTrade(int currUic) {
    final List<int> uics = [
      ...positions.map((it) => it.uic),
      ...orders.map((it) => it.uic),
    ];

    if (uics.length != 10 && !uics.contains(currUic)) {
      final infoPrice = infoPriceVM.infoPriceOf(currUic);

      double cr =
          double.parse((infoPrice?.lastTraded ?? 0.0).toStringAsFixed(2));

      int amount = 0;
      double sl = 0.0;
      double sltl = 0.0;

      if (cr != 0) {
        amount = (tradeVM.balance.cashAvailableForTrading - 2) ~/ cr;
        if (amount == 0) {
          amount = 1;
        } else if (amount < 0) {
          amount = 0;
        }

        if (tradeVM.balance.cashAvailableForTrading - 2 > cr && amount > 0) {
          double sldiff =
              double.parse(((2 / amount.ceil())).toStringAsFixed(2));

          sl = cr - sldiff;
          sl += 0.01;
        } else {
          sl = 0.0;
        }

        sltl = 0.01;
      }

      return TradeModel(
        uic: instVM.currUic,
        amount: amount,
        op: cr,
        sl: sl,
        sltl: sltl,
      );
    }

    return null;
  }

  TradeModel buildOrderTrade(SaxoOrderModel order) {
    final tlOrder = order.relatedOpenOrders.firstOrNull;

    return TradeModel(
      uic: order.uic,
      amount: order.amount.toInt(),
      op: order.price,
      sl: tlOrder?.orderPrice ?? 0.0,
      sltl: tlOrder?.trailingStopStep ?? 0.0,
      order: order,
    );
  }

  TradeModel buildPositionTrade(SaxoPositionModel position) {
    final rlOrder = tradeVM.orderOf(position.uic);

    return TradeModel(
      uic: position.uic,
      amount: position.amount.toInt(),
      op: position.openPrice,
      sl: rlOrder?.price ?? 0.0,
      sltl: rlOrder?.trailingStopStep ?? 0.0,
      position: position,
    );
  }

  Future<void> init1() async {
    tradeVM.loadFakeData();
    await tradeVM.syncMessages();
  }

  void loadFakeData() {
    final now = DateTime.now();

    // --- Balance ---
    _balance = SaxoBalanceModel(
      cashBalance: 12480.50,
      cashBlocked: 1200.00,
      cashAvailableForTrading: 11280.50,
      cashBlockedFromWithdrawal: 0.0,
      unrealizedMarginClosedProfitLoss: 0.0,
      unrealizedMarginOpenProfitLoss: 318.40,
      unrealizedMarginProfitLoss: 318.40,
      unrealizedPositionsValue: 9840.20,
      totalValue: 21120.70,
      currency: 'USD',
      currencyDecimals: 2,
      initialMargin: InitialMargin(
        collateralAvailable: 11280.50,
        marginAvailable: 11280.50,
        marginCollateralNotAvailable: 0.0,
        marginUsedByCurrentPositions: 1200.00,
        marginUtilizationPct: 9.6,
        netEquityForMargin: 21120.70,
        otherCollateralDeduction: 0.0,
        collateralCreditValue: null,
      ),
      marginAndCollateralUtilizationPct: 9.6,
      marginAvailableForTrading: 11280.50,
      marginCollateralNotAvailable: 0.0,
      marginCollateralNotAvailableDetail: MarginCollateralNotAvailableDetail(
        initialFxHaircut: 0.0,
        maintenanceFxHaircut: 0.0,
      ),
      marginExposureCoveragePct: 100.0,
      marginNetExposure: 9840.20,
      marginUsedByCurrentPositions: 1200.00,
      marginUtilizationPct: 9.6,
      calculationReliability: 'Ok',
      costToClosePositions: 12.50,
      changesScheduled: false,
      closedPositionsCount: 0,
      collateralAvailable: 11280.50,
      collateralCreditValue: null,
      corporateActionUnrealizedAmounts: 0.0,
      financingAccruals: 0.0,
      isPortfolioMarginModelSimple: true,
      netEquityForMargin: 21120.70,
      netPositionsCount: 5,
      nonMarginPositionsValue: 0.0,
      openIpoOrdersCount: 0,
      openPositionsCount: 5,
      optionPremiumsMarketValue: 0.0,
      ordersCount: 3,
      otherCollateral: 0.0,
      settlementValue: 0.0,
      spendingPowerDetail: {},
      transactionsNotBooked: 0.0,
      triggerOrdersCount: 3,
    );

    // --- Positions ---
    // Each entry: (uic, ticker, openPrice, currentPrice, amount, daysAgo)
    final posData = [
      (211, 'AAPL', 185.50, 181.30, 10.0, 5),
      (261, 'MSFT', 415.00, 412.30, 5.0, 12),
      (2087, 'NVDA', 620.00, 645.80, 3.0, 3),
      (773599, 'GOOGL', 170.00, 173.50, 12.0, 7),
    ];

    _positions = posData.map((d) {
      final (uic, _, openPrice, currentPrice, amount, daysAgo) = d;
      final pnl = (currentPrice - openPrice) * amount;
      final marketVal = currentPrice * amount;
      return SaxoPositionModel(
        positionId: 'POS_$uic',
        netPositionId: 'NET_$uic',
        accountId: 'FAKE_ACC_001',
        amount: amount,
        assetType: 'Stock',
        canBeClosed: true,
        closeConversionRateSettled: false,
        correlationKey: 'CK_$uic',
        executionTimeOpen: now.subtract(Duration(days: daysAgo)),
        isForceOpen: false,
        isMarketOpen: true,
        lockedByBackOffice: false,
        openBondPoolFactor: 1.0,
        openPrice: openPrice,
        openPriceIncludingCosts: openPrice + 0.01,
        relatedOpenOrders: [],
        sourceOrderId: 'ORD_SRC_$uic',
        spotDate: null,
        status: 'Open',
        uic: uic,
        valueDate: now,
        ask: currentPrice + 0.05,
        bid: currentPrice - 0.05,
        calculationReliability: 'Ok',
        conversionRateCurrent: 1.0,
        conversionRateOpen: 1.0,
        currentBondPoolFactor: 1.0,
        currentPrice: currentPrice,
        currentPriceDelayMinutes: 0,
        currentPriceType: 'Bid',
        exposure: marketVal,
        exposureCurrency: 'USD',
        exposureInBaseCurrency: marketVal,
        instrumentPriceDayPercentChange:
            ((currentPrice - openPrice) / openPrice) * 100,
        marketState: 'Open',
        marketValue: marketVal,
        marketValueInBaseCurrency: marketVal,
        profitLossOnTrade: pnl,
        profitLossOnTradeInBaseCurrency: pnl,
        profitLossOnTradeIntraday: pnl * 0.4,
        profitLossOnTradeIntradayInBaseCurrency: pnl * 0.4,
        tradeCostsTotal: -0.10,
        tradeCostsTotalInBaseCurrency: -0.10,
      );
    }).toList();

    _positions
        .sort((a, b) => b.executionTimeOpen.compareTo(a.executionTimeOpen));

    // --- Orders ---
    // Each entry: (uic, limitPrice, currentPrice, amount, daysAgo)
    final ordData = [
      (207, 'AMZN', 178.00, 184.20, 15.0, 2),
      (29529022, 'META', 490.00, 502.10, 6.0, 1),
      (1067, 'JPM', 195.00, 198.30, 20.0, 4),
    ];

    _orders = ordData.map((d) {
      final (uic, _, limitPrice, currentPrice, amount, daysAgo) = d;
      final marketVal = currentPrice * amount;
      final slPrice = limitPrice - (limitPrice * 0.01);
      return SaxoOrderModel(
        orderId: 'ORD_$uic',
        uic: uic,
        accountId: 'FAKE_ACC_001',
        clientId: 'FAKE_CLIENT_001',
        orderRelation: 'StandAlone',
        openOrderType: 'Limit',
        price: limitPrice,
        status: 'Working',
        orderTime: now.subtract(Duration(days: daysAgo)),
        amount: amount,
        assetType: 'Stock',
        buySell: 'Buy',
        correlationKey: 'CK_ORD_$uic',
        duration: {'DurationType': 'GoodTillCancel'},
        relatedOpenOrders: [
          SaxoRelatedOrderModel(
            amount: amount,
            duration: {'DurationType': 'GoodTillCancel'},
            openOrderType: 'TrailingStopIfTraded',
            orderId: 'ORD_SL_$uic',
            orderPrice: slPrice,
            status: 'Working',
            trailingStopDistanceToMarket: limitPrice * 0.01,
            trailingStopStep: 0.01,
          ),
        ],
        adviceNote: '',
        ask: currentPrice + 0.05,
        bid: currentPrice - 0.05,
        calculationReliability: 'Ok',
        clientNote: '',
        currentPrice: currentPrice,
        currentPriceDelayMinutes: 0,
        currentPriceType: 'Bid',
        distanceToMarket: currentPrice - limitPrice,
        exchange: {'ExchangeId': 'NASDAQ'},
        ipoSubscriptionFee: 0.0,
        isExtendedHoursEnabled: false,
        isForceOpen: false,
        isMarketOpen: true,
        marketPrice: currentPrice,
        marketState: 'Open',
        marketValue: marketVal,
        nonTradableReason: 'None',
        orderAmountType: 'Quantity',
        tradingStatus: 'Tradable',
        trailingStopDistanceToMarket: null,
        trailingStopStep: null,
      );
    }).toList();

    _orders.sort((a, b) => b.orderTime.compareTo(a.orderTime));
  }

  Future<void> syncBalance() async {
    _balance = await userServ.getBalance();
  }

  Future<void> syncOrders() async {
    _orders = await tradeServ.getOrders();
    _orders.sort(
      (a, b) => b.orderTime.compareTo(a.orderTime),
    );
  }

  Future<void> syncPositions() async {
    _positions = await tradeServ.getPositions();
    _positions.sort(
      (a, b) => b.executionTimeOpen.compareTo(a.executionTimeOpen),
    );
  }

  Future<void> syncMessages() async {
    _messages = await psqlServ.selectTradeMessages();
    _messages.sort((a, b) {
      return b.dateTime.compareTo(a.dateTime);
    });

    try {
      await tradeServ.syncTradeMessages();

      _messages = await psqlServ.selectTradeMessages();
      _messages.sort((a, b) {
        return b.dateTime.compareTo(a.dateTime);
      });
    } catch (_) {}
  }

  Future<void> markAllAsSeenMessages() async {
    for (var msg in messages) {
      if (!msg.seen) {
        await psqlServ.markAsSeenTradeMessage(msg.messageId);
      }
    }

    _messages = await psqlServ.selectTradeMessages();
    _messages.sort((a, b) {
      return b.dateTime.compareTo(a.dateTime);
    });
  }

  //~

  Future<void> pushTrade({
    required TradeModel trade,
    required double lastTraded,
  }) async {
    await tradeServ.placeBuyOrder(
      uic: trade.uic,
      amount: trade.amount,
      orderPrice: lastTraded,
      slPrice: trade.sl,
      trailingStopStep: trade.sltl,
    );

    await tradeVM.syncMessages();
  }

  Future<void> cancelTrade({
    required TradeModel trade,
  }) async {
    await tradeServ.cancelOrder(orderIds: [trade.order!.orderId]);

    await tradeVM.syncMessages();
  }

  //~

  List<PopoverController> ctrlTradePopovers = [];
}
