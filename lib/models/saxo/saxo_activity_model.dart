// abstract class SaxoActivityModel {}

// class SaxoOrderActivityModel extends SaxoActivityModel {
//   final double amount;
//   final String assetType;
//   final String buySell;
//   final Map<String, dynamic> duration;
//   final String orderId;
//   final String orderType;
//   final String orderRelation;
//   final double? price;
//   final List<String>? relatedOrderId;
//   final List<String>? relatedOrderIds;
//   final String status;
//   final String subStatus;
//   final String symbol;
//   final double? trailingStopDistanceToMarket;
//   final double? trailingStopStep;
//   final int uic;
//   final String? externalReference;
//   final bool isSecondCurrencyOrder;
//   final String sequenceId;
//   final DateTime activityTime;
//   final String activityType;
//   final String accountId;
//   final String clientId;

//   SaxoOrderActivityModel({
//     required this.amount,
//     required this.assetType,
//     required this.buySell,
//     required this.duration,
//     required this.orderId,
//     required this.orderType,
//     required this.orderRelation,
//     required this.price,
//     required this.relatedOrderId,
//     required this.relatedOrderIds,
//     required this.status,
//     required this.subStatus,
//     required this.symbol,
//     required this.trailingStopDistanceToMarket,
//     required this.trailingStopStep,
//     required this.uic,
//     required this.externalReference,
//     required this.isSecondCurrencyOrder,
//     required this.sequenceId,
//     required this.activityTime,
//     required this.activityType,
//     required this.accountId,
//     required this.clientId,
//   });

//   factory SaxoOrderActivityModel.fromJson(Map<String, dynamic> json) {
//     return SaxoOrderActivityModel(
//       amount: json['Amount'],
//       assetType: json['AssetType'],
//       buySell: json['BuySell'],
//       duration: Map<String, dynamic>.from(json['Duration']),
//       orderId: json['OrderId'],
//       orderType: json['OrderType'],
//       orderRelation: json['OrderRelation'],
//       price: json['Price'],
//       relatedOrderId: json['RelatedOrderId'] != null
//           ? List<String>.from(json['RelatedOrderId'])
//           : null,
//       relatedOrderIds: json['RelatedOrderId'] != null
//           ? List<String>.from(json['RelatedOrderIds'])
//           : null,
//       status: json['Status'],
//       subStatus: json['SubStatus'],
//       symbol: json['Symbol'],
//       trailingStopDistanceToMarket: json['TrailingStopDistanceToMarket'],
//       trailingStopStep: json['TrailingStopStep'],
//       uic: json['Uic'],
//       externalReference: json['ExternalReference'],
//       isSecondCurrencyOrder: json['IsSecondCurrencyOrder'],
//       sequenceId: json['SequenceId'],
//       activityTime: DateTime.parse(json['ActivityTime']).toLocal(),
//       activityType: json['ActivityType'],
//       accountId: json['AccountId'],
//       clientId: json['ClientId'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'Amount': amount,
//       'AssetType': assetType,
//       'BuySell': buySell,
//       'Duration': duration,
//       'OrderId': orderId,
//       'OrderType': orderType,
//       'OrderRelation': orderRelation,
//       'Price': price,
//       'RelatedOrderId': relatedOrderId,
//       'RelatedOrderIds': relatedOrderIds,
//       'Status': status,
//       'SubStatus': subStatus,
//       'Symbol': symbol,
//       'TrailingStopDistanceToMarket': trailingStopDistanceToMarket,
//       'TrailingStopStep': trailingStopStep,
//       'Uic': uic,
//       'ExternalReference': externalReference,
//       'IsSecondCurrencyOrder': isSecondCurrencyOrder,
//       'SequenceId': sequenceId,
//       'ActivityTime': activityTime.toUtc().toIso8601String(),
//       'ActivityType': activityType,
//       'AccountId': accountId,
//       'ClientId': clientId,
//     };
//   }
// }

// class SaxoPositionActivityModel extends SaxoActivityModel {
//   final double amount;
//   final double? fillAmount;
//   final String assetType;
//   final String buySell;
//   final double commission;
//   final String currencyCode;
//   final DateTime executionTime;
//   final double openPrice;
//   final double openSpot;
//   final String positionEvent;
//   final String positionId;
//   final double? price;
//   final String priceType;
//   final String sourceOrderId;
//   final DateTime spotDate;
//   final String symbol;
//   final int uic;
//   final DateTime valueDate;
//   final double totalCost;
//   final double tradedValue;
//   final String? externalReference;
//   final int direction;
//   final int originatingToolId;
//   final String? venue;
//   final String allocationType;
//   final List<String> correlationType;
//   final String sequenceId;
//   final DateTime activityTime;
//   final String activityType;
//   final String accountId;
//   final String clientId;

//   SaxoPositionActivityModel({
//     required this.amount,
//     required this.fillAmount,
//     required this.assetType,
//     required this.buySell,
//     required this.commission,
//     required this.currencyCode,
//     required this.executionTime,
//     required this.openPrice,
//     required this.openSpot,
//     required this.positionEvent,
//     required this.positionId,
//     required this.price,
//     required this.priceType,
//     required this.sourceOrderId,
//     required this.spotDate,
//     required this.symbol,
//     required this.uic,
//     required this.valueDate,
//     required this.totalCost,
//     required this.tradedValue,
//     required this.externalReference,
//     required this.direction,
//     required this.originatingToolId,
//     required this.venue,
//     required this.allocationType,
//     required this.correlationType,
//     required this.sequenceId,
//     required this.activityTime,
//     required this.activityType,
//     required this.accountId,
//     required this.clientId,
//   });

//   factory SaxoPositionActivityModel.fromJson(Map<String, dynamic> json) {
//     return SaxoPositionActivityModel(
//       amount: json['Amount'],
//       fillAmount: json['FillAmount'],
//       assetType: json['AssetType'],
//       buySell: json['BuySell'],
//       commission: json['Commission'],
//       currencyCode: json['CurrencyCode'],
//       executionTime: DateTime.parse(json['ExecutionTime']).toLocal(),
//       openPrice: json['OpenPrice'],
//       openSpot: json['OpenSpot'],
//       positionEvent: json['PositionEvent'],
//       positionId: json['PositionId'],
//       price: json['Price'],
//       priceType: json['PriceType'],
//       sourceOrderId: json['SourceOrderId'],
//       spotDate: DateTime.parse(json['SpotDate']).toLocal(),
//       symbol: json['Symbol'],
//       uic: json['Uic'],
//       valueDate: DateTime.parse(json['ValueDate']).toLocal(),
//       totalCost: json['TotalCost'],
//       tradedValue: json['TradedValue'],
//       externalReference: json['ExternalReference'],
//       direction: json['Direction'],
//       originatingToolId: json['OriginatingToolId'],
//       venue: json['Venue'],
//       allocationType: json['AllocationType'],
//       correlationType: List<String>.from(json['CorrelationType']),
//       sequenceId: json['SequenceId'],
//       activityTime: DateTime.parse(json['ActivityTime']).toLocal(),
//       activityType: json['ActivityType'],
//       accountId: json['AccountId'],
//       clientId: json['ClientId'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'Amount': amount,
//       'FillAmount': fillAmount,
//       'AssetType': assetType,
//       'BuySell': buySell,
//       'Commission': commission,
//       'CurrencyCode': currencyCode,
//       'ExecutionTime': executionTime.toUtc().toIso8601String(),
//       'OpenPrice': openPrice,
//       'OpenSpot': openSpot,
//       'PositionEvent': positionEvent,
//       'PositionId': positionId,
//       'Price': price,
//       'PriceType': priceType,
//       'SourceOrderId': sourceOrderId,
//       'SpotDate': spotDate.toUtc().toIso8601String(),
//       'Symbol': symbol,
//       'Uic': uic,
//       'ValueDate': valueDate.toUtc().toIso8601String(),
//       'TotalCost': totalCost,
//       'TradedValue': tradedValue,
//       'ExternalReference': externalReference,
//       'Direction': direction,
//       'OriginatingToolId': originatingToolId,
//       'Venue': venue,
//       'AllocationType': allocationType,
//       'CorrelationType': correlationType,
//       'SequenceId': sequenceId,
//       'ActivityTime': activityTime.toUtc().toIso8601String(),
//       'ActivityType': activityType,
//       'AccountId': accountId,
//       'ClientId': clientId,
//     };
//   }
// }
