import 'package:lasitrade/models/saxo/saxo_instrument_data_model.dart';

class SaxoHistoricalOrderModel {
  final String orderId;
  final int uic;

  final String userId;
  final String accountId;
  final String clientId;

  final String orderRelation;
  final String orderType;

  final double? price;
  final double? averagePrice;

  final String status;
  final String subStatus;

  final DateTime activityTime;
  final double amount;
  final String assetType;
  final String buySell;

  final String correlationKey;
  final SaxoInstrumentDisplayAndFormatModel displayAndFormat;

  final Map<String, dynamic> duration;
  final String handledBy;
  final String logId;

  final List<String> relatedOrders;

  SaxoHistoricalOrderModel({
    required this.orderId,
    required this.uic,
    required this.userId,
    required this.accountId,
    required this.clientId,
    required this.orderRelation,
    required this.orderType,
    required this.price,
    required this.averagePrice,
    required this.status,
    required this.subStatus,
    required this.activityTime,
    required this.amount,
    required this.assetType,
    required this.buySell,
    required this.correlationKey,
    required this.displayAndFormat,
    required this.duration,
    required this.handledBy,
    required this.logId,
    required this.relatedOrders,
  });

  factory SaxoHistoricalOrderModel.fromJson(Map<String, dynamic> json) {
    final displayAndFormat = Map<String, dynamic>.from(
      json['DisplayAndFormat'],
    );
    displayAndFormat.putIfAbsent('Uic', () => json['Uic']);

    return SaxoHistoricalOrderModel(
      orderId: json['OrderId'],
      uic: json['Uic'],
      userId: json['UserId'],
      accountId: json['AccountId'],
      clientId: json['ClientId'],
      orderRelation: json['OrderRelation'],
      orderType: json['OrderType'],
      price: json['Price'],
      averagePrice: json['AveragePrice'],
      status: json['Status'],
      subStatus: json['SubStatus'],
      activityTime: DateTime.parse(json['ActivityTime']).toLocal(),
      amount: json['Amount'],
      assetType: json['AssetType'],
      buySell: json['BuySell'],
      correlationKey: json['CorrelationKey'],
      displayAndFormat: SaxoInstrumentDisplayAndFormatModel.fromJson(
        displayAndFormat,
      ),
      duration: Map<String, dynamic>.from(json['Duration']),
      handledBy: json['HandledBy'],
      logId: json['LogId'],
      relatedOrders: List<String>.from(json['RelatedOrders']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OrderId': orderId,
      'Uic': uic,
      'UserId': userId,
      'AccountId': accountId,
      'ClientId': clientId,
      'OrderRelation': orderRelation,
      'OrderType': orderType,
      'Price': price,
      'AveragePrice': averagePrice,
      'Status': status,
      'SubStatus': subStatus,
      'ActivityTime': activityTime.toUtc().toIso8601String(),
      'Amount': amount,
      'AssetType': assetType,
      'BuySell': buySell,
      'CorrelationKey': correlationKey,
      'DisplayAndFormat': displayAndFormat.toJson(),
      'Duration': duration,
      'HandledBy': handledBy,
      'LogId': logId,
      'RelatedOrders': relatedOrders,
    };
  }
}

class SaxoOrderModel {
  final String orderId;
  final int uic;
  final String accountId;
  final String clientId;
  final String orderRelation;
  final String openOrderType;
  final double price;
  final String status;
  final DateTime orderTime;
  final double amount;
  final String assetType;
  final String buySell;
  final String correlationKey;
  final Map<String, dynamic> duration;
  final List<SaxoRelatedOrderModel> relatedOpenOrders;
  //
  final String adviceNote;
  final double? ask;
  final double? bid;
  final String calculationReliability;
  final String clientNote;
  final double currentPrice;
  final int currentPriceDelayMinutes;
  final String currentPriceType;
  final double distanceToMarket;
  final Map<String, dynamic> exchange;
  final double ipoSubscriptionFee;
  final bool isExtendedHoursEnabled;
  final bool isForceOpen;
  final bool isMarketOpen;
  final double marketPrice;
  final String marketState;
  final double marketValue;
  final String nonTradableReason;
  final String orderAmountType;
  final String tradingStatus;
  //
  final double? trailingStopDistanceToMarket;
  final double? trailingStopStep;

  SaxoOrderModel({
    required this.orderId,
    required this.uic,
    required this.accountId,
    required this.clientId,
    required this.orderRelation,
    required this.openOrderType,
    required this.price,
    required this.status,
    required this.orderTime,
    required this.amount,
    required this.assetType,
    required this.buySell,
    required this.correlationKey,
    required this.duration,
    required this.relatedOpenOrders,
    //
    required this.adviceNote,
    required this.ask,
    required this.bid,
    required this.calculationReliability,
    required this.clientNote,
    required this.currentPrice,
    required this.currentPriceDelayMinutes,
    required this.currentPriceType,
    required this.distanceToMarket,
    required this.exchange,
    required this.ipoSubscriptionFee,
    required this.isExtendedHoursEnabled,
    required this.isForceOpen,
    required this.isMarketOpen,
    required this.marketPrice,
    required this.marketState,
    required this.marketValue,
    required this.nonTradableReason,
    required this.orderAmountType,
    required this.tradingStatus,
    required this.trailingStopDistanceToMarket,
    required this.trailingStopStep,
  });

  bool get isTrailing => openOrderType == 'TrailingStopIfTraded';

  factory SaxoOrderModel.fromJson(Map<String, dynamic> json) {
    return SaxoOrderModel(
      orderId: json['OrderId'],
      uic: json['Uic'],
      accountId: json['AccountId'],
      clientId: json['ClientId'],
      orderRelation: json['OrderRelation'],
      openOrderType: json['OpenOrderType'],
      price: json['Price'],
      status: json['Status'],
      orderTime: DateTime.parse(json['OrderTime']).toLocal(),
      amount: json['Amount'],
      assetType: json['AssetType'],
      buySell: json['BuySell'],
      correlationKey: json['CorrelationKey'],
      duration: Map<String, dynamic>.from(json['Duration']),
      relatedOpenOrders: List<Map<String, dynamic>>.from(
        json['RelatedOpenOrders'],
      ).map((it) => SaxoRelatedOrderModel.fromJson(it)).toList(),
      //
      adviceNote: json['AdviceNote'],
      ask: json['Ask'],
      bid: json['Bid'],
      calculationReliability: json['CalculationReliability'],
      clientNote: json['ClientNote'],
      currentPrice: json['CurrentPrice'],
      currentPriceDelayMinutes: json['CurrentPriceDelayMinutes'],
      currentPriceType: json['CurrentPriceType'],
      distanceToMarket: json['DistanceToMarket'],
      exchange: Map<String, dynamic>.from(json['Exchange']),
      ipoSubscriptionFee: json['IpoSubscriptionFee'],
      isExtendedHoursEnabled: json['IsExtendedHoursEnabled'],
      isForceOpen: json['IsForceOpen'],
      isMarketOpen: json['IsMarketOpen'],
      marketPrice: json['MarketPrice'],
      marketState: json['MarketState'],
      marketValue: json['MarketValue'],
      nonTradableReason: json['NonTradableReason'],
      orderAmountType: json['OrderAmountType'],
      tradingStatus: json['TradingStatus'],
      //
      trailingStopDistanceToMarket: json['TrailingStopDistanceToMarket'],
      trailingStopStep: json['TrailingStopStep'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OrderId': orderId,
      'Uic': uic,
      'AccountId': accountId,
      'ClientId': clientId,
      'OrderRelation': orderRelation,
      'OpenOrderType': openOrderType,
      'Price': price,
      'Status': status,
      'OrderTime': orderTime.toUtc().toIso8601String(),
      'Amount': amount,
      'AssetType': assetType,
      'BuySell': buySell,
      'CorrelationKey': correlationKey,
      'Duration': duration,
      'RelatedOpenOrders': relatedOpenOrders.map((it) => it.toJson()),
      //
      'AdviceNote': adviceNote,
      'Ask': ask,
      'Bid': bid,
      'CalculationReliability': calculationReliability,
      'ClientNote': clientNote,
      'CurrentPrice': currentPrice,
      'CurrentPriceDelayMinutes': currentPriceDelayMinutes,
      'CurrentPriceType': currentPriceType,
      'DistanceToMarket': distanceToMarket,
      'Exchange': exchange,
      'IpoSubscriptionFee': ipoSubscriptionFee,
      'IsExtendedHoursEnabled': isExtendedHoursEnabled,
      'IsForceOpen': isForceOpen,
      'IsMarketOpen': isMarketOpen,
      'MarketPrice': marketPrice,
      'MarketState': marketState,
      'MarketValue': marketValue,
      'NonTradableReason': nonTradableReason,
      'OrderAmountType': orderAmountType,
      'TradingStatus': tradingStatus,
      //
      'TrailingStopDistanceToMarket': trailingStopDistanceToMarket,
      'TrailingStopStep': trailingStopStep,
    };
  }
}

class SaxoRelatedOrderModel {
  final double amount;
  final Map<String, dynamic> duration;
  final String openOrderType;
  final String orderId;
  final double orderPrice;
  final String status;
  final double? trailingStopDistanceToMarket;
  final double? trailingStopStep;

  SaxoRelatedOrderModel({
    required this.amount,
    required this.duration,
    required this.openOrderType,
    required this.orderId,
    required this.orderPrice,
    required this.status,
    required this.trailingStopDistanceToMarket,
    required this.trailingStopStep,
  });

  factory SaxoRelatedOrderModel.fromJson(Map<String, dynamic> json) {
    return SaxoRelatedOrderModel(
      amount: json['Amount'],
      duration: Map<String, dynamic>.from(json['Duration']),
      openOrderType: json['OpenOrderType'],
      orderId: json['OrderId'],
      orderPrice: json['OrderPrice'],
      status: json['Status'],
      trailingStopDistanceToMarket: json['TrailingStopDistanceToMarket'],
      trailingStopStep: json['TrailingStopStep'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Amount': amount,
      'Duration': duration,
      'OpenOrderType': openOrderType,
      'OrderId': orderId,
      'OrderPrice': orderPrice,
      'Status': status,
      'TrailingStopDistanceToMarket': trailingStopDistanceToMarket,
      'TrailingStopStep': trailingStopStep,
    };
  }
}
