class SaxoInstrumentDetailsModel {
  final int uic;
  final String symbol;
  final String underlyingTypeCategory;
  final String tradingStatus;
  final String tradingSignals;

  final List<String> tradableAs;
  final List<String> tradableOn;

  final bool affiliateInfoRequired;
  final int amountDecimals;
  final String assetType;
  final String currencyCode;
  final double defaultAmount;
  final double defaultSlippage;
  final String defaultSlippageType;
  final String description;
  final SaxoInstrumentDetailsExchangeModel exchange;
  final int formatDecimals;
  final int formatOrderDecimals;
  final double? fractionalMinimumLotSize;
  final int groupId;
  final double incrementSize;
  final bool isBarrierEqualsStrike;
  final bool isComplex;
  final bool? isExtendedTradingHoursEnabled;
  final bool isOcoOrderSupported;
  final bool isPEAEligible;
  final bool isPEASMEEligible;
  final bool isRedemptionByAmounts;
  final bool isSwitchBySameCurrency;
  final bool isTradable;
  final String lotSizeType;
  final double minimumTradeSize;
  final String nonTradableReason;
  final SaxoInstrumentDetailsOrderDistancesModel orderDistances;
  final String? priceCurrency;
  final double? priceToContractFactor;
  final int? primaryListing;
  final List<Map<String, dynamic>>? relatedInstruments;
  final List<int>? relatedOptionRoots;
  final List<SaxoInstrumentDetailsRelatedOptionRootsEnhancedModel>?
      relatedOptionRootsEnhanced;
  final bool? shortTradeDisabled;
  final List<double> standardAmounts;
  final List<dynamic> supportedOrderTriggerPriceTypes;
  final List<String> supportedOrderTypes;
  final List<String>? supportedStrategies;
  final SaxoInstrumentDetailsTickSizeSchemeModel? tickSizeScheme;

  SaxoInstrumentDetailsModel({
    required this.uic,
    required this.symbol,
    required this.underlyingTypeCategory,
    required this.tradingStatus,
    required this.tradingSignals,
    required this.tradableAs,
    required this.tradableOn,
    required this.affiliateInfoRequired,
    required this.amountDecimals,
    required this.assetType,
    required this.currencyCode,
    required this.defaultAmount,
    required this.defaultSlippage,
    required this.defaultSlippageType,
    required this.description,
    required this.exchange,
    required this.formatDecimals,
    required this.formatOrderDecimals,
    required this.fractionalMinimumLotSize,
    required this.groupId,
    required this.incrementSize,
    required this.isBarrierEqualsStrike,
    required this.isComplex,
    required this.isExtendedTradingHoursEnabled,
    required this.isOcoOrderSupported,
    required this.isPEAEligible,
    required this.isPEASMEEligible,
    required this.isRedemptionByAmounts,
    required this.isSwitchBySameCurrency,
    required this.isTradable,
    required this.lotSizeType,
    required this.minimumTradeSize,
    required this.nonTradableReason,
    required this.orderDistances,
    required this.priceCurrency,
    required this.priceToContractFactor,
    required this.primaryListing,
    required this.relatedInstruments,
    required this.relatedOptionRoots,
    required this.relatedOptionRootsEnhanced,
    required this.shortTradeDisabled,
    required this.standardAmounts,
    required this.supportedOrderTriggerPriceTypes,
    required this.supportedOrderTypes,
    required this.supportedStrategies,
    required this.tickSizeScheme,
  });

  factory SaxoInstrumentDetailsModel.fromJson(Map<String, dynamic> json) {
    return SaxoInstrumentDetailsModel(
      uic: json['Uic'],
      symbol: json['Symbol'],
      underlyingTypeCategory: json['UnderlyingTypeCategory'],
      tradingStatus: json['TradingStatus'],
      tradableAs: List<String>.from(json['TradableAs']),
      tradableOn: List<String>.from(json['TradableOn']),
      affiliateInfoRequired: json['AffiliateInfoRequired'],
      amountDecimals: json['AmountDecimals'],
      assetType: json['AssetType'],
      currencyCode: json['CurrencyCode'],
      defaultAmount: json['DefaultAmount'],
      defaultSlippage: json['DefaultSlippage'],
      defaultSlippageType: json['DefaultSlippageType'],
      description: json['Description'],
      exchange: SaxoInstrumentDetailsExchangeModel.fromJson(json['Exchange']),
      formatDecimals: json['Format']['Decimals'],
      formatOrderDecimals: json['Format']['OrderDecimals'],
      fractionalMinimumLotSize: json['FractionalMinimumLotSize'],
      groupId: json['GroupId'],
      incrementSize: json['IncrementSize'],
      isBarrierEqualsStrike: json['IsBarrierEqualsStrike'],
      isComplex: json['IsComplex'],
      isExtendedTradingHoursEnabled: json['IsExtendedTradingHoursEnabled'],
      isOcoOrderSupported: json['IsOcoOrderSupported'],
      isPEAEligible: json['IsPEAEligible'],
      isPEASMEEligible: json['IsPEASMEEligible'],
      isRedemptionByAmounts: json['IsRedemptionByAmounts'],
      isSwitchBySameCurrency: json['IsSwitchBySameCurrency'],
      isTradable: json['IsTradable'],
      lotSizeType: json['LotSizeType'],
      minimumTradeSize: json['MinimumTradeSize'],
      nonTradableReason: json['NonTradableReason'],
      orderDistances: SaxoInstrumentDetailsOrderDistancesModel.fromJson(
          json['OrderDistances']),
      priceCurrency: json['PriceCurrency'],
      priceToContractFactor: json['PriceToContractFactor'],
      primaryListing: json['PrimaryListing'],
      relatedInstruments: json['RelatedInstruments'] != null
          ? List<Map<String, dynamic>>.from(json['RelatedInstruments'])
          : null,
      relatedOptionRoots: json['RelatedOptionRoots'] != null
          ? List<int>.from(json['RelatedOptionRoots'])
          : null,
      relatedOptionRootsEnhanced: json['RelatedOptionRootsEnhanced'] != null
          ? List<Map<String, dynamic>>.from(json['RelatedOptionRootsEnhanced'])
              .map((it) =>
                  SaxoInstrumentDetailsRelatedOptionRootsEnhancedModel.fromJson(
                      it))
              .toList()
          : null,
      shortTradeDisabled: json['ShortTradeDisabled'],
      standardAmounts: List<double>.from(json['StandardAmounts']),
      supportedOrderTriggerPriceTypes:
          List<dynamic>.from(json['SupportedOrderTriggerPriceTypes']),
      supportedOrderTypes: List<String>.from(json['SupportedOrderTypes']),
      supportedStrategies: json['SupportedStrategies'] != null
          ? List<String>.from(json['SupportedStrategies'])
          : null,
      tickSizeScheme: json['TickSizeScheme'] != null
          ? SaxoInstrumentDetailsTickSizeSchemeModel.fromJson(
              json['TickSizeScheme'])
          : null,
      tradingSignals: json['TradingSignals'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Uic': uic,
      'Symbol': symbol,
      'UnderlyingTypeCategory': underlyingTypeCategory,
      'TradingStatus': tradingStatus,
      'TradableAs': tradableAs,
      'TradableOn': tradableOn,
      'AffiliateInfoRequired': affiliateInfoRequired,
      'AmountDecimals': amountDecimals,
      'AssetType': assetType,
      'CurrencyCode': currencyCode,
      'DefaultAmount': defaultAmount,
      'DefaultSlippage': defaultSlippage,
      'DefaultSlippageType': defaultSlippageType,
      'Description': description,
      'Exchange': exchange.toJson(),
      'Format': {
        'Decimals': formatDecimals,
        'OrderDecimals': formatOrderDecimals,
      },
      'FractionalMinimumLotSize': fractionalMinimumLotSize,
      'GroupId': groupId,
      'IncrementSize': incrementSize,
      'IsBarrierEqualsStrike': isBarrierEqualsStrike,
      'IsComplex': isComplex,
      'IsExtendedTradingHoursEnabled': isExtendedTradingHoursEnabled,
      'IsOcoOrderSupported': isOcoOrderSupported,
      'IsPEAEligible': isPEAEligible,
      'IsPEASMEEligible': isPEASMEEligible,
      'IsRedemptionByAmounts': isRedemptionByAmounts,
      'IsSwitchBySameCurrency': isSwitchBySameCurrency,
      'IsTradable': isTradable,
      'LotSizeType': lotSizeType,
      'MinimumTradeSize': minimumTradeSize,
      'NonTradableReason': nonTradableReason,
      'OrderDistances': orderDistances.toJson(),
      'PriceCurrency': priceCurrency,
      'PriceToContractFactor': priceToContractFactor,
      'PrimaryListing': primaryListing,
      'RelatedInstruments': relatedInstruments,
      'RelatedOptionRoots': relatedOptionRoots,
      'RelatedOptionRootsEnhanced':
          relatedOptionRootsEnhanced?.map((it) => it.toJson()).toList(),
      'ShortTradeDisabled': shortTradeDisabled,
      'StandardAmounts': standardAmounts,
      'SupportedOrderTriggerPriceTypes': supportedOrderTriggerPriceTypes,
      'SupportedOrderTypes': supportedOrderTypes,
      'SupportedStrategies': supportedStrategies,
      'TickSizeScheme': tickSizeScheme?.toJson(),
      'TradingSignals': tradingSignals,
    };
  }
}

class SaxoInstrumentDetailsOrderDistancesModel {
  final double entryDefaultDistance;
  final String entryDefaultDistanceType;
  final double limitDefaultDistance;
  final String limitDefaultDistanceType;
  final double stopLimitDefaultDistance;
  final String stopLimitDefaultDistanceType;
  final double stopLossDefaultDistance;
  final String stopLossDefaultDistanceType;
  final bool stopLossDefaultEnabled;
  final String stopLossDefaultOrderType;
  final double takeProfitDefaultDistance;
  final String takeProfitDefaultDistanceType;
  final bool takeProfitDefaultEnabled;

  SaxoInstrumentDetailsOrderDistancesModel({
    required this.entryDefaultDistance,
    required this.entryDefaultDistanceType,
    required this.limitDefaultDistance,
    required this.limitDefaultDistanceType,
    required this.stopLimitDefaultDistance,
    required this.stopLimitDefaultDistanceType,
    required this.stopLossDefaultDistance,
    required this.stopLossDefaultDistanceType,
    required this.stopLossDefaultEnabled,
    required this.stopLossDefaultOrderType,
    required this.takeProfitDefaultDistance,
    required this.takeProfitDefaultDistanceType,
    required this.takeProfitDefaultEnabled,
  });

  factory SaxoInstrumentDetailsOrderDistancesModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SaxoInstrumentDetailsOrderDistancesModel(
      entryDefaultDistance: json['EntryDefaultDistance'],
      entryDefaultDistanceType: json['EntryDefaultDistanceType'],
      limitDefaultDistance: json['LimitDefaultDistance'],
      limitDefaultDistanceType: json['LimitDefaultDistanceType'],
      stopLimitDefaultDistance: json['StopLimitDefaultDistance'],
      stopLimitDefaultDistanceType: json['StopLimitDefaultDistanceType'],
      stopLossDefaultDistance: json['StopLossDefaultDistance'],
      stopLossDefaultDistanceType: json['StopLossDefaultDistanceType'],
      stopLossDefaultEnabled: json['StopLossDefaultEnabled'],
      stopLossDefaultOrderType: json['StopLossDefaultOrderType'],
      takeProfitDefaultDistance: json['TakeProfitDefaultDistance'],
      takeProfitDefaultDistanceType: json['TakeProfitDefaultDistanceType'],
      takeProfitDefaultEnabled: json['TakeProfitDefaultEnabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EntryDefaultDistance': entryDefaultDistance,
      'EntryDefaultDistanceType': entryDefaultDistanceType,
      'LimitDefaultDistance': limitDefaultDistance,
      'LimitDefaultDistanceType': limitDefaultDistanceType,
      'StopLimitDefaultDistance': stopLimitDefaultDistance,
      'StopLimitDefaultDistanceType': stopLimitDefaultDistanceType,
      'StopLossDefaultDistance': stopLossDefaultDistance,
      'StopLossDefaultDistanceType': stopLossDefaultDistanceType,
      'StopLossDefaultEnabled': stopLossDefaultEnabled,
      'StopLossDefaultOrderType': stopLossDefaultOrderType,
      'TakeProfitDefaultDistance': takeProfitDefaultDistance,
      'TakeProfitDefaultDistanceType': takeProfitDefaultDistanceType,
      'TakeProfitDefaultEnabled': takeProfitDefaultEnabled,
    };
  }
}

class SaxoInstrumentDetailsRelatedOptionRootsEnhancedModel {
  final String assetType;
  final int optionRootId;
  final String optionType;
  final List<String> supportedStrategies;

  SaxoInstrumentDetailsRelatedOptionRootsEnhancedModel({
    required this.assetType,
    required this.optionRootId,
    required this.optionType,
    required this.supportedStrategies,
  });

  factory SaxoInstrumentDetailsRelatedOptionRootsEnhancedModel.fromJson(
      Map<String, dynamic> json) {
    return SaxoInstrumentDetailsRelatedOptionRootsEnhancedModel(
      assetType: json['AssetType'],
      optionRootId: json['OptionRootId'],
      optionType: json['OptionType'],
      supportedStrategies: List<String>.from(json['SupportedStrategies']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AssetType': assetType,
      'OptionRootId': optionRootId,
      'OptionType': optionType,
      'SupportedStrategies': supportedStrategies,
    };
  }
}

class SaxoInstrumentDetailsTickSizeSchemeModel {
  final double defaultTickSize;
  final List<Map<String, dynamic>> elements;

  SaxoInstrumentDetailsTickSizeSchemeModel({
    required this.defaultTickSize,
    required this.elements,
  });

  factory SaxoInstrumentDetailsTickSizeSchemeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SaxoInstrumentDetailsTickSizeSchemeModel(
      defaultTickSize: json['DefaultTickSize'],
      elements: List<Map<String, dynamic>>.from(json['Elements']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DefaultTickSize': defaultTickSize,
      'Elements': elements,
    };
  }
}

class SaxoInstrumentDetailsExchangeModel {
  final String countryCode;
  final String exchangeId;
  final String name;
  final String timeZoneId;

  SaxoInstrumentDetailsExchangeModel({
    required this.countryCode,
    required this.exchangeId,
    required this.name,
    required this.timeZoneId,
  });

  factory SaxoInstrumentDetailsExchangeModel.fromJson(
      Map<String, dynamic> json) {
    return SaxoInstrumentDetailsExchangeModel(
      countryCode: json['CountryCode'],
      exchangeId: json['ExchangeId'],
      name: json['Name'],
      timeZoneId: json['TimeZoneId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CountryCode': countryCode,
      'ExchangeId': exchangeId,
      'Name': name,
      'TimeZoneId': timeZoneId,
    };
  }
}
