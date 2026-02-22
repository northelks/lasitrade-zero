class SaxoAccountModel {
  final String accountId;
  final String accountType;
  final String accountSubType;
  //
  final String accountKey;
  final String accountGroupKey;
  //
  final String clientId;
  final String clientKey;
  //
  final double? accountValueProtectionLimit;
  final bool active;
  final bool canUseCashPositionsAsMarginCollateral;
  final bool cfdBorrowingCostsActive;
  //
  final String currency;
  final int currencyDecimals;
  //
  final List<String> legalAssetTypes;
  final List<String> fractionalOrderEnabledAssetTypes;
  //
  final bool fractionalOrderEnabled;
  final bool individualMargining;
  final bool isCurrencyConversionAtSettlementTime;
  final bool isMarginTradingAllowed;
  final bool isShareable;
  final bool isTrialAccount;
  final bool supportsAccountValueProtectionLimit;
  final bool useCashPositionsAsMarginCollateral;
  final bool portfolioBasedMarginEnabled;
  //
  final String marginCalculationMethod;
  final String marginLendingEnabled;
  //
  final String managementType;
  final List<String> sharing;
  //
  final DateTime creationDate;

  SaxoAccountModel({
    required this.accountId,
    required this.accountType,
    required this.accountSubType,
    //
    required this.accountKey,
    required this.accountGroupKey,
    //
    required this.clientId,
    required this.clientKey,
    //
    required this.accountValueProtectionLimit,
    required this.active,
    required this.canUseCashPositionsAsMarginCollateral,
    required this.cfdBorrowingCostsActive,
    //
    required this.currency,
    required this.currencyDecimals,
    //
    required this.legalAssetTypes,
    required this.fractionalOrderEnabledAssetTypes,
    //
    required this.fractionalOrderEnabled,
    required this.individualMargining,
    required this.isCurrencyConversionAtSettlementTime,
    required this.isMarginTradingAllowed,
    required this.isShareable,
    required this.isTrialAccount,
    required this.supportsAccountValueProtectionLimit,
    required this.useCashPositionsAsMarginCollateral,
    required this.portfolioBasedMarginEnabled,
    //
    required this.marginCalculationMethod,
    required this.marginLendingEnabled,
    //
    required this.managementType,
    required this.sharing,
    //
    required this.creationDate,
  });

  factory SaxoAccountModel.fromJson(Map<String, dynamic> json) {
    return SaxoAccountModel(
      accountId: json['AccountId'],
      accountType: json['AccountType'],
      accountSubType: json['AccountSubType'],
      //
      accountKey: json['AccountKey'],
      accountGroupKey: json['AccountGroupKey'],
      //
      clientId: json['ClientId'],
      clientKey: json['ClientKey'],
      //
      accountValueProtectionLimit: json['AccountValueProtectionLimit'],
      active: json['Active'],
      canUseCashPositionsAsMarginCollateral:
          json['CanUseCashPositionsAsMarginCollateral'],
      cfdBorrowingCostsActive: json['CfdBorrowingCostsActive'],
      //
      currency: json['Currency'],
      currencyDecimals: json['CurrencyDecimals'],
      //
      legalAssetTypes: List<String>.from(json['LegalAssetTypes']),
      fractionalOrderEnabledAssetTypes:
          List<String>.from(json['FractionalOrderEnabledAssetTypes']),
      //
      fractionalOrderEnabled: json['FractionalOrderEnabled'],
      individualMargining: json['IndividualMargining'],
      isCurrencyConversionAtSettlementTime:
          json['IsCurrencyConversionAtSettlementTime'],
      isMarginTradingAllowed: json['IsMarginTradingAllowed'],
      isShareable: json['IsShareable'],
      isTrialAccount: json['IsTrialAccount'],
      supportsAccountValueProtectionLimit:
          json['SupportsAccountValueProtectionLimit'],
      useCashPositionsAsMarginCollateral:
          json['UseCashPositionsAsMarginCollateral'],
      portfolioBasedMarginEnabled: json['PortfolioBasedMarginEnabled'],
      //
      marginCalculationMethod: json['MarginCalculationMethod'],
      marginLendingEnabled: json['MarginLendingEnabled'],
      //
      managementType: json['ManagementType'],
      sharing: List<String>.from(json['Sharing']),
      //
      creationDate: DateTime.parse(json['CreationDate']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AccountId': accountId,
      'AccountType': accountType,
      'AccountSubType': accountSubType,
      //
      'AccountKey': accountKey,
      'AccountGroupKey': accountGroupKey,
      //
      'ClientId': clientId,
      'ClientKey': clientKey,
      //
      'AccountValueProtectionLimit': accountValueProtectionLimit,
      'Active': active,
      'CanUseCashPositionsAsMarginCollateral':
          canUseCashPositionsAsMarginCollateral,
      'CfdBorrowingCostsActive': cfdBorrowingCostsActive,
      //
      'Currency': currency,
      'CurrencyDecimals': currencyDecimals,
      //
      'LegalAssetTypes': legalAssetTypes,
      'FractionalOrderEnabledAssetTypes': fractionalOrderEnabledAssetTypes,
      //
      'FractionalOrderEnabled': fractionalOrderEnabled,
      'IndividualMargining': individualMargining,
      'IsCurrencyConversionAtSettlementTime':
          isCurrencyConversionAtSettlementTime,
      'IsMarginTradingAllowed': isMarginTradingAllowed,
      'IsShareable': isShareable,
      'IsTrialAccount': isTrialAccount,
      'SupportsAccountValueProtectionLimit':
          supportsAccountValueProtectionLimit,
      'UseCashPositionsAsMarginCollateral': useCashPositionsAsMarginCollateral,
      'PortfolioBasedMarginEnabled': portfolioBasedMarginEnabled,
      //
      'MarginCalculationMethod': marginCalculationMethod,
      'MarginLendingEnabled': marginLendingEnabled,
      //
      'ManagementType': managementType,
      'Sharing': sharing,
      //
      'CreationDate': creationDate.toUtc().toIso8601String(),
    };
  }
}
