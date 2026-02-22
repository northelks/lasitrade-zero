class SaxoPositionModel {
  final String positionId;
  final String netPositionId;
  //
  final String accountId;
  final double amount;
  final String assetType;
  final bool canBeClosed;
  final bool closeConversionRateSettled;
  final String correlationKey;
  final DateTime executionTimeOpen;
  final bool isForceOpen;
  final bool isMarketOpen;
  final bool lockedByBackOffice;
  final double openBondPoolFactor;
  final double openPrice;
  final double openPriceIncludingCosts;
  final List<String> relatedOpenOrders;
  final String sourceOrderId;
  final DateTime? spotDate;
  final String status;
  final int uic;
  final DateTime valueDate;
  //
  final double ask;
  final double bid;
  final String calculationReliability;
  final double conversionRateCurrent;
  final double conversionRateOpen;
  final double currentBondPoolFactor;
  final double currentPrice;
  final int currentPriceDelayMinutes;
  final String currentPriceType;
  final double exposure;
  final String exposureCurrency;
  final double exposureInBaseCurrency;
  final double instrumentPriceDayPercentChange;
  final String marketState;
  final double marketValue;
  final double marketValueInBaseCurrency;
  final double profitLossOnTrade;
  final double profitLossOnTradeInBaseCurrency;
  final double profitLossOnTradeIntraday;
  final double profitLossOnTradeIntradayInBaseCurrency;
  final double tradeCostsTotal;
  final double tradeCostsTotalInBaseCurrency;

  SaxoPositionModel({
    required this.positionId,
    required this.netPositionId,
    //
    required this.accountId,
    required this.amount,
    required this.assetType,
    required this.canBeClosed,
    required this.closeConversionRateSettled,
    required this.correlationKey,
    required this.executionTimeOpen,
    required this.isForceOpen,
    required this.isMarketOpen,
    required this.lockedByBackOffice,
    required this.openBondPoolFactor,
    required this.openPrice,
    required this.openPriceIncludingCosts,
    required this.relatedOpenOrders,
    required this.sourceOrderId,
    required this.spotDate,
    required this.status,
    required this.uic,
    required this.valueDate,
    //
    required this.ask,
    required this.bid,
    required this.calculationReliability,
    required this.conversionRateCurrent,
    required this.conversionRateOpen,
    required this.currentBondPoolFactor,
    required this.currentPrice,
    required this.currentPriceDelayMinutes,
    required this.currentPriceType,
    required this.exposure,
    required this.exposureCurrency,
    required this.exposureInBaseCurrency,
    required this.instrumentPriceDayPercentChange,
    required this.marketState,
    required this.marketValue,
    required this.marketValueInBaseCurrency,
    required this.profitLossOnTrade,
    required this.profitLossOnTradeInBaseCurrency,
    required this.profitLossOnTradeIntraday,
    required this.profitLossOnTradeIntradayInBaseCurrency,
    required this.tradeCostsTotal,
    required this.tradeCostsTotalInBaseCurrency,
  });

  factory SaxoPositionModel.fromJson(Map<String, dynamic> json0) {
    final json1 = json0['PositionBase'];
    final json2 = json0['PositionView'];

    return SaxoPositionModel(
      positionId: json0['PositionId'],
      netPositionId: json0['NetPositionId'],
      //
      accountId: json1['AccountId'],
      amount: json1['Amount'],
      assetType: json1['AssetType'],
      canBeClosed: json1['CanBeClosed'],
      closeConversionRateSettled: json1['CloseConversionRateSettled'],
      correlationKey: json1['CorrelationKey'],
      executionTimeOpen: DateTime.parse(json1['ExecutionTimeOpen']).toLocal(),
      isForceOpen: json1['IsForceOpen'],
      isMarketOpen: json1['IsMarketOpen'],
      lockedByBackOffice: json1['LockedByBackOffice'],
      openBondPoolFactor: json1['OpenBondPoolFactor'],
      openPrice: json1['OpenPrice'],
      openPriceIncludingCosts: json1['OpenPriceIncludingCosts'],
      relatedOpenOrders: List<String>.from(json1['RelatedOpenOrders']),
      sourceOrderId: json1['SourceOrderId'],
      spotDate: DateTime.tryParse(json1['SpotDate'] ?? '')?.toLocal(),
      status: json1['Status'],
      uic: json1['Uic'],
      valueDate: DateTime.parse(json1['ValueDate']).toLocal(),
      //
      ask: json2['Ask'],
      bid: json2['Bid'],
      calculationReliability: json2['CalculationReliability'],
      conversionRateCurrent: json2['ConversionRateCurrent'],
      conversionRateOpen: json2['ConversionRateOpen'],
      currentBondPoolFactor: json2['CurrentBondPoolFactor'],
      currentPrice: json2['CurrentPrice'],
      currentPriceDelayMinutes: json2['CurrentPriceDelayMinutes'],
      currentPriceType: json2['CurrentPriceType'],
      exposure: json2['Exposure'],
      exposureCurrency: json2['ExposureCurrency'],
      exposureInBaseCurrency: json2['ExposureInBaseCurrency'],
      instrumentPriceDayPercentChange: json2['InstrumentPriceDayPercentChange'],
      marketState: json2['MarketState'],
      marketValue: json2['MarketValue'],
      marketValueInBaseCurrency: json2['MarketValueInBaseCurrency'],
      profitLossOnTrade: json2['ProfitLossOnTrade'],
      profitLossOnTradeInBaseCurrency: json2['ProfitLossOnTradeInBaseCurrency'],
      profitLossOnTradeIntraday: json2['ProfitLossOnTradeIntraday'],
      profitLossOnTradeIntradayInBaseCurrency:
          json2['ProfitLossOnTradeIntradayInBaseCurrency'],
      tradeCostsTotal: json2['TradeCostsTotal'],
      tradeCostsTotalInBaseCurrency: json2['TradeCostsTotalInBaseCurrency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PositionId': positionId,
      'NetPositionId': netPositionId,
      //
      'AccountId': accountId,
      'Amount': amount,
      'AssetType': assetType,
      'CanBeClosed': canBeClosed,
      'CloseConversionRateSettled': closeConversionRateSettled,
      'CorrelationKey': correlationKey,
      'ExecutionTimeOpen': executionTimeOpen.toUtc().toIso8601String(),
      'IsForceOpen': isForceOpen,
      'IsMarketOpen': isMarketOpen,
      'LockedByBackOffice': lockedByBackOffice,
      'OpenBondPoolFactor': openBondPoolFactor,
      'OpenPrice': openPrice,
      'OpenPriceIncludingCosts': openPriceIncludingCosts,
      'RelatedOpenOrders': relatedOpenOrders,
      'SourceOrderId': sourceOrderId,
      'SpotDate': spotDate?.toUtc().toIso8601String(),
      'Status': status,
      'Uic': uic,
      'ValueDate': valueDate.toUtc().toIso8601String(),
      //
      'Ask': ask,
      'Bid': bid,
      'CalculationReliability': calculationReliability,
      'ConversionRateCurrent': conversionRateCurrent,
      'ConversionRateOpen': conversionRateOpen,
      'CurrentBondPoolFactor': currentBondPoolFactor,
      'CurrentPrice': currentPrice,
      'CurrentPriceDelayMinutes': currentPriceDelayMinutes,
      'CurrentPriceType': currentPriceType,
      'Exposure': exposure,
      'ExposureCurrency': exposureCurrency,
      'ExposureInBaseCurrency': exposureInBaseCurrency,
      'InstrumentPriceDayPercentChange': instrumentPriceDayPercentChange,
      'MarketState': marketState,
      'MarketValue': marketValue,
      'MarketValueInBaseCurrency': marketValueInBaseCurrency,
      'ProfitLossOnTrade': profitLossOnTrade,
      'ProfitLossOnTradeInBaseCurrency': profitLossOnTradeInBaseCurrency,
      'ProfitLossOnTradeIntraday': profitLossOnTradeIntraday,
      'ProfitLossOnTradeIntradayInBaseCurrency':
          profitLossOnTradeIntradayInBaseCurrency,
      'TradeCostsTotal': tradeCostsTotal,
      'TradeCostsTotalInBaseCurrency': tradeCostsTotalInBaseCurrency,
    };
  }
}

class SaxoClosedPosition1Model {
  final String accountId;
  final double amount;
  final String assetType;
  final String buyOrSell;
  final String clientId;
  final double closedProfitLoss;
  final double closedProfitLossInBaseCurrency;
  final double closingBondPoolFactor;
  final double closingMarketValue;
  final double closingMarketValueInBaseCurrency;
  final String closingMethod;
  final String closingPositionId;
  final double closingPrice;
  final bool conversionRateInstrumentToBaseSettledClosing;
  final bool conversionRateInstrumentToBaseSettledOpening;
  final double costClosing;
  final double costClosingInBaseCurrency;
  final double costOpening;
  final double costOpeningInBaseCurrency;
  final DateTime executionTimeClose;
  final DateTime executionTimeOpen;
  final double openingBondPoolFactor;
  final String openingPositionId;
  final double openPrice;
  final int uic;

  SaxoClosedPosition1Model({
    required this.accountId,
    required this.amount,
    required this.assetType,
    required this.buyOrSell,
    required this.clientId,
    required this.closedProfitLoss,
    required this.closedProfitLossInBaseCurrency,
    required this.closingBondPoolFactor,
    required this.closingMarketValue,
    required this.closingMarketValueInBaseCurrency,
    required this.closingMethod,
    required this.closingPositionId,
    required this.closingPrice,
    required this.conversionRateInstrumentToBaseSettledClosing,
    required this.conversionRateInstrumentToBaseSettledOpening,
    required this.costClosing,
    required this.costClosingInBaseCurrency,
    required this.costOpening,
    required this.costOpeningInBaseCurrency,
    required this.executionTimeClose,
    required this.executionTimeOpen,
    required this.openingBondPoolFactor,
    required this.openingPositionId,
    required this.openPrice,
    required this.uic,
  });

  factory SaxoClosedPosition1Model.fromJson(Map<String, dynamic> json) {
    json = json['ClosedPosition'];

    return SaxoClosedPosition1Model(
      accountId: json['AccountId'],
      amount: json['Amount'],
      assetType: json['AssetType'],
      buyOrSell: json['BuyOrSell'],
      clientId: json['ClientId'],
      closedProfitLoss: json['ClosedProfitLoss'],
      closedProfitLossInBaseCurrency: json['ClosedProfitLossInBaseCurrency'],
      closingBondPoolFactor: json['ClosingBondPoolFactor'],
      closingMarketValue: json['ClosingMarketValue'],
      closingMarketValueInBaseCurrency:
          json['ClosingMarketValueInBaseCurrency'],
      closingMethod: json['ClosingMethod'],
      closingPositionId: json['ClosingPositionId'],
      closingPrice: json['ClosingPrice'],
      conversionRateInstrumentToBaseSettledClosing:
          json['ConversionRateInstrumentToBaseSettledClosing'],
      conversionRateInstrumentToBaseSettledOpening:
          json['ConversionRateInstrumentToBaseSettledOpening'],
      costClosing: json['CostClosing'],
      costClosingInBaseCurrency: json['CostClosingInBaseCurrency'],
      costOpening: json['CostOpening'],
      costOpeningInBaseCurrency: json['CostOpeningInBaseCurrency'],
      executionTimeClose: DateTime.parse(json['ExecutionTimeClose']).toLocal(),
      executionTimeOpen: DateTime.parse(json['ExecutionTimeOpen']).toLocal(),
      openingBondPoolFactor: json['OpeningBondPoolFactor'],
      openingPositionId: json['OpeningPositionId'],
      openPrice: json['OpenPrice'],
      uic: json['Uic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AccountId': accountId,
      'Amount': amount,
      'AssetType': assetType,
      'BuyOrSell': buyOrSell,
      'ClientId': clientId,
      'ClosedProfitLoss': closedProfitLoss,
      'ClosedProfitLossInBaseCurrency': closedProfitLossInBaseCurrency,
      'ClosingBondPoolFactor': closingBondPoolFactor,
      'ClosingMarketValue': closingMarketValue,
      'ClosingMarketValueInBaseCurrency': closingMarketValueInBaseCurrency,
      'ClosingMethod': closingMethod,
      'ClosingPositionId': closingPositionId,
      'ClosingPrice': closingPrice,
      'ConversionRateInstrumentToBaseSettledClosing':
          conversionRateInstrumentToBaseSettledClosing,
      'ConversionRateInstrumentToBaseSettledOpening':
          conversionRateInstrumentToBaseSettledOpening,
      'CostClosing': costClosing,
      'CostClosingInBaseCurrency': costClosingInBaseCurrency,
      'CostOpening': costOpening,
      'CostOpeningInBaseCurrency': costOpeningInBaseCurrency,
      'ExecutionTimeClose': executionTimeClose.toUtc().toIso8601String(),
      'ExecutionTimeOpen': executionTimeOpen.toUtc().toIso8601String(),
      'OpeningBondPoolFactor': openingBondPoolFactor,
      'OpeningPositionId': openingPositionId,
      'OpenPrice': openPrice,
      'Uic': uic,
    };
  }
}
