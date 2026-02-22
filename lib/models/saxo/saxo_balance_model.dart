import 'package:intl/intl.dart';

class SaxoBalanceModel {
  final double cashBalance;
  final double cashBlocked;
  final double cashAvailableForTrading; // <
  final double cashBlockedFromWithdrawal;
  //
  final double unrealizedMarginClosedProfitLoss;
  final double unrealizedMarginOpenProfitLoss;
  final double unrealizedMarginProfitLoss;
  final double unrealizedPositionsValue;
  //
  final double totalValue;
  //
  final String currency;
  final int currencyDecimals;
  //
  final InitialMargin initialMargin;
  final double marginAndCollateralUtilizationPct;
  final double marginAvailableForTrading;
  final double marginCollateralNotAvailable;
  final MarginCollateralNotAvailableDetail marginCollateralNotAvailableDetail;
  final double marginExposureCoveragePct;
  final double marginNetExposure;
  final double marginUsedByCurrentPositions;
  final double marginUtilizationPct;
  //
  final String calculationReliability;
  final double costToClosePositions;
  //
  final bool changesScheduled;
  final int closedPositionsCount;
  //
  final double collateralAvailable;
  final CollateralCreditValue? collateralCreditValue;
  //
  final double corporateActionUnrealizedAmounts;
  //
  final double financingAccruals;
  //
  final bool isPortfolioMarginModelSimple;
  //
  final double netEquityForMargin;
  final int netPositionsCount;
  //
  final double nonMarginPositionsValue;
  final int openIpoOrdersCount;
  final int openPositionsCount;
  final double optionPremiumsMarketValue;
  //
  final int ordersCount;
  //
  final double otherCollateral;
  final double settlementValue;
  final Map<String, dynamic> spendingPowerDetail;
  //
  final double transactionsNotBooked;
  final int triggerOrdersCount;

  SaxoBalanceModel({
    required this.cashBalance,
    required this.cashBlocked,
    required this.cashAvailableForTrading,
    required this.cashBlockedFromWithdrawal,
    //
    required this.unrealizedMarginClosedProfitLoss,
    required this.unrealizedMarginOpenProfitLoss,
    required this.unrealizedMarginProfitLoss,
    required this.unrealizedPositionsValue,
    //
    required this.totalValue,
    //
    required this.currency,
    required this.currencyDecimals,
    //
    required this.initialMargin,
    required this.marginAndCollateralUtilizationPct,
    required this.marginAvailableForTrading,
    required this.marginCollateralNotAvailable,
    required this.marginCollateralNotAvailableDetail,
    required this.marginExposureCoveragePct,
    required this.marginNetExposure,
    required this.marginUsedByCurrentPositions,
    required this.marginUtilizationPct,
    //
    required this.calculationReliability,
    required this.costToClosePositions,
    //
    required this.changesScheduled,
    required this.closedPositionsCount,
    //
    required this.collateralAvailable,
    required this.collateralCreditValue,
    //
    required this.corporateActionUnrealizedAmounts,
    //
    required this.financingAccruals,
    //
    required this.isPortfolioMarginModelSimple,
    //
    required this.netEquityForMargin,
    required this.netPositionsCount,
    //
    required this.nonMarginPositionsValue,
    required this.openIpoOrdersCount,
    required this.openPositionsCount,
    required this.optionPremiumsMarketValue,
    //
    required this.ordersCount,
    //
    required this.otherCollateral,
    required this.settlementValue,
    required this.spendingPowerDetail,
    //
    required this.transactionsNotBooked,
    required this.triggerOrdersCount,
  });

  String get cashAvailableForTradingFormated {
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    ).format(cashAvailableForTrading);
  }

  String get totalValueFormated {
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    ).format(totalValue);
  }

  factory SaxoBalanceModel.fromJson(Map<String, dynamic> json) {
    return SaxoBalanceModel(
      cashBalance: json['CashBalance'],
      cashBlocked: json['CashBlocked'],
      cashAvailableForTrading: json['CashAvailableForTrading'],
      cashBlockedFromWithdrawal: json['CashBlockedFromWithdrawal'],
      //
      unrealizedMarginClosedProfitLoss:
          json['UnrealizedMarginClosedProfitLoss'],
      unrealizedMarginOpenProfitLoss: json['UnrealizedMarginOpenProfitLoss'],
      unrealizedMarginProfitLoss: json['UnrealizedMarginProfitLoss'],
      unrealizedPositionsValue: json['UnrealizedPositionsValue'],
      //
      totalValue: json['TotalValue'],
      //
      currency: json['Currency'],
      currencyDecimals: json['CurrencyDecimals'],
      //
      initialMargin: InitialMargin.fromJson(json['InitialMargin']),
      marginAndCollateralUtilizationPct:
          json['MarginAndCollateralUtilizationPct'],
      marginAvailableForTrading: json['MarginAvailableForTrading'],
      marginCollateralNotAvailable: json['MarginCollateralNotAvailable'],
      marginCollateralNotAvailableDetail:
          MarginCollateralNotAvailableDetail.fromJson(
              json['MarginCollateralNotAvailableDetail']),
      marginExposureCoveragePct: json['MarginExposureCoveragePct'],
      marginNetExposure: json['MarginNetExposure'],
      marginUsedByCurrentPositions: json['MarginUsedByCurrentPositions'],
      marginUtilizationPct: json['MarginUtilizationPct'],
      //
      calculationReliability: json['CalculationReliability'],
      costToClosePositions: json['CostToClosePositions'],
      //
      changesScheduled: json['ChangesScheduled'],
      closedPositionsCount: json['ClosedPositionsCount'],
      //
      collateralAvailable: json['CollateralAvailable'],
      collateralCreditValue: json['CollateralCreditValue'] != null
          ? CollateralCreditValue.fromJson(json['CollateralCreditValue'])
          : null,
      //
      corporateActionUnrealizedAmounts:
          json['CorporateActionUnrealizedAmounts'],
      //
      financingAccruals: json['FinancingAccruals'],
      //
      isPortfolioMarginModelSimple: json['IsPortfolioMarginModelSimple'],
      //
      netEquityForMargin: json['NetEquityForMargin'],
      netPositionsCount: json['NetPositionsCount'],
      //
      nonMarginPositionsValue: json['NonMarginPositionsValue'],
      openIpoOrdersCount: json['OpenIpoOrdersCount'],
      openPositionsCount: json['OpenPositionsCount'],
      optionPremiumsMarketValue: json['OptionPremiumsMarketValue'],
      //
      ordersCount: json['OrdersCount'],
      //
      otherCollateral: json['OtherCollateral'],
      settlementValue: json['SettlementValue'],
      spendingPowerDetail:
          Map<String, dynamic>.from(json['SpendingPowerDetail']),
      //
      transactionsNotBooked: json['TransactionsNotBooked'],
      triggerOrdersCount: json['TriggerOrdersCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CashBalance': cashBalance,
      'CashBlocked': cashBlocked,
      'CashAvailableForTrading': cashAvailableForTrading,
      'CashBlockedFromWithdrawal': cashBlockedFromWithdrawal,
      //
      'UnrealizedMarginClosedProfitLoss': unrealizedMarginClosedProfitLoss,
      'UnrealizedMarginOpenProfitLoss': unrealizedMarginOpenProfitLoss,
      'UnrealizedMarginProfitLoss': unrealizedMarginProfitLoss,
      'UnrealizedPositionsValue': unrealizedPositionsValue,
      //
      'TotalValue': totalValue,
      //
      'Currency': currency,
      'CurrencyDecimals': currencyDecimals,
      //
      'InitialMargin': initialMargin.toJson(),
      'MarginAndCollateralUtilizationPct': marginAndCollateralUtilizationPct,
      'MarginAvailableForTrading': marginAvailableForTrading,
      'MarginCollateralNotAvailable': marginCollateralNotAvailable,
      'MarginCollateralNotAvailableDetail':
          marginCollateralNotAvailableDetail.toJson(),
      'MarginExposureCoveragePct': marginExposureCoveragePct,
      'MarginNetExposure': marginNetExposure,
      'MarginUsedByCurrentPositions': marginUsedByCurrentPositions,
      'MarginUtilizationPct': marginUtilizationPct,
      //
      'CalculationReliability': calculationReliability,
      'CostToClosePositions': costToClosePositions,
      //
      'ChangesScheduled': changesScheduled,
      'ClosedPositionsCount': closedPositionsCount,
      //
      'CollateralAvailable': collateralAvailable,
      'CollateralCreditValue': collateralCreditValue?.toJson(),
      //
      'CorporateActionUnrealizedAmounts': corporateActionUnrealizedAmounts,
      //
      'FinancingAccruals': financingAccruals,
      //
      'IsPortfolioMarginModelSimple': isPortfolioMarginModelSimple,
      //
      'NetEquityForMargin': netEquityForMargin,
      'NetPositionsCount': netPositionsCount,
      //
      'NonMarginPositionsValue': nonMarginPositionsValue,
      'OpenIpoOrdersCount': openIpoOrdersCount,
      'OpenPositionsCount': openPositionsCount,
      'OptionPremiumsMarketValue': optionPremiumsMarketValue,
      //
      'OrdersCount': ordersCount,
      //
      'OtherCollateral': otherCollateral,
      'SettlementValue': settlementValue,
      'SpendingPowerDetail': spendingPowerDetail,
      //
      'TransactionsNotBooked': transactionsNotBooked,
      'TriggerOrdersCount': triggerOrdersCount,
    };
  }
}

class InitialMargin {
  final double collateralAvailable;
  final double marginAvailable;
  final double marginCollateralNotAvailable;
  final double marginUsedByCurrentPositions;
  final double marginUtilizationPct;
  final double netEquityForMargin;
  final double otherCollateralDeduction;
  final CollateralCreditValue? collateralCreditValue;

  InitialMargin({
    required this.collateralAvailable,
    required this.marginAvailable,
    required this.marginCollateralNotAvailable,
    required this.marginUsedByCurrentPositions,
    required this.marginUtilizationPct,
    required this.netEquityForMargin,
    required this.otherCollateralDeduction,
    required this.collateralCreditValue,
  });

  factory InitialMargin.fromJson(Map<String, dynamic> json) {
    return InitialMargin(
      collateralAvailable: json['CollateralAvailable'],
      marginAvailable: json['MarginAvailable'],
      marginCollateralNotAvailable: json['MarginCollateralNotAvailable'],
      marginUsedByCurrentPositions: json['MarginUsedByCurrentPositions'],
      marginUtilizationPct: json['MarginUtilizationPct'],
      netEquityForMargin: json['NetEquityForMargin'],
      otherCollateralDeduction: json['OtherCollateralDeduction'],
      collateralCreditValue: json['CollateralCreditValue'] != null
          ? CollateralCreditValue.fromJson(json['CollateralCreditValue'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CollateralAvailable': collateralAvailable,
      'MarginAvailable': marginAvailable,
      'MarginCollateralNotAvailable': marginCollateralNotAvailable,
      'MarginUsedByCurrentPositions': marginUsedByCurrentPositions,
      'MarginUtilizationPct': marginUsedByCurrentPositions,
      'NetEquityForMargin': netEquityForMargin,
      'OtherCollateralDeduction': otherCollateralDeduction,
      'CollateralCreditValue': collateralCreditValue?.toJson(),
    };
  }
}

class CollateralCreditValue {
  final double line;
  final double utilizationPct;

  CollateralCreditValue({
    required this.line,
    required this.utilizationPct,
  });

  factory CollateralCreditValue.fromJson(Map<String, dynamic> json) {
    return CollateralCreditValue(
      line: json['Line'],
      utilizationPct: json['UtilizationPct'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Line': line,
      'UtilizationPct': utilizationPct,
    };
  }
}

class MarginCollateralNotAvailableDetail {
  final double initialFxHaircut;
  final double maintenanceFxHaircut;

  MarginCollateralNotAvailableDetail({
    required this.initialFxHaircut,
    required this.maintenanceFxHaircut,
  });

  factory MarginCollateralNotAvailableDetail.fromJson(
      Map<String, dynamic> json) {
    return MarginCollateralNotAvailableDetail(
        initialFxHaircut: json['InitialFxHaircut'],
        maintenanceFxHaircut: json['MaintenanceFxHaircut']);
  }

  Map<String, dynamic> toJson() {
    return {
      'InitialFxHaircut': initialFxHaircut,
      'MaintenanceFxHaircut': maintenanceFxHaircut,
    };
  }
}
