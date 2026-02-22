class SaxoClientModel {
  final String clientId;
  final String clientType;
  final String name;
  //
  final String clientKey;
  //
  final String defaultAccountId;
  final String defaultAccountKey;
  final String defaultCurrency;
  //
  final int currencyDecimals;
  //
  final double accountValueProtectionLimit;
  final List<String> allowedNettingProfiles;
  final String allowedTradingSessions;
  final String contractOptionsTradingProfile;
  //
  final bool forceOpenDefaultValue;
  final bool isMarginTradingAllowed;
  final bool isVariationMarginEligible;
  final bool reduceExposureOnly;
  final bool supportsAccountValueProtectionLimit;
  //
  final bool legalAssetTypesAreIndicative;
  final List<String> legalAssetTypes;
  //
  final String marginCalculationMethod;
  final String marginMonitoringMode;
  //
  final String partnerPlatformId;
  //
  final String positionNettingMethod;
  final String positionNettingMode;
  final String positionNettingProfile;

  SaxoClientModel({
    required this.clientId,
    required this.clientType,
    required this.name,
    //
    required this.clientKey,
    //
    required this.defaultAccountId,
    required this.defaultAccountKey,
    required this.defaultCurrency,
    //
    required this.currencyDecimals,
    //
    required this.accountValueProtectionLimit,
    required this.allowedNettingProfiles,
    required this.allowedTradingSessions,
    required this.contractOptionsTradingProfile,
    //
    required this.forceOpenDefaultValue,
    required this.isMarginTradingAllowed,
    required this.isVariationMarginEligible,
    required this.reduceExposureOnly,
    required this.supportsAccountValueProtectionLimit,
    //
    required this.legalAssetTypesAreIndicative,
    required this.legalAssetTypes,
    //
    required this.marginCalculationMethod,
    required this.marginMonitoringMode,
    //
    required this.partnerPlatformId,
    //
    required this.positionNettingMethod,
    required this.positionNettingMode,
    required this.positionNettingProfile,
  });

  factory SaxoClientModel.fromJson(Map<String, dynamic> json) {
    return SaxoClientModel(
      clientId: json['ClientId'],
      clientType: json['ClientType'],
      name: json['Name'],
      //
      clientKey: json['ClientKey'],
      //
      defaultAccountId: json['DefaultAccountId'],
      defaultAccountKey: json['DefaultAccountKey'],
      defaultCurrency: json['DefaultCurrency'],
      //
      currencyDecimals: json['CurrencyDecimals'],
      //
      accountValueProtectionLimit: json['AccountValueProtectionLimit'],
      allowedNettingProfiles: List<String>.from(json['AllowedNettingProfiles']),
      allowedTradingSessions: json['AllowedTradingSessions'],
      contractOptionsTradingProfile: json['ContractOptionsTradingProfile'],
      //
      forceOpenDefaultValue: json['ForceOpenDefaultValue'],
      isMarginTradingAllowed: json['IsMarginTradingAllowed'],
      isVariationMarginEligible: json['IsVariationMarginEligible'],
      reduceExposureOnly: json['ReduceExposureOnly'],
      supportsAccountValueProtectionLimit:
          json['SupportsAccountValueProtectionLimit'],
      //
      legalAssetTypesAreIndicative: json['LegalAssetTypesAreIndicative'],
      legalAssetTypes: List<String>.from(json['LegalAssetTypes']),
      //
      marginCalculationMethod: json['MarginCalculationMethod'],
      marginMonitoringMode: json['MarginMonitoringMode'],
      //
      partnerPlatformId: json['PartnerPlatformId'],
      //
      positionNettingMethod: json['PositionNettingMethod'],
      positionNettingMode: json['PositionNettingMode'],
      positionNettingProfile: json['PositionNettingProfile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ClientId': clientId,
      'ClientType': clientType,
      'Name': name,
      //
      'ClientKey': clientKey,
      //
      'DefaultAccountId': defaultAccountId,
      'DefaultAccountKey': defaultAccountKey,
      'DefaultCurrency': defaultCurrency,
      //
      'CurrencyDecimals': currencyDecimals,
      //
      'AccountValueProtectionLimit': accountValueProtectionLimit,
      'AllowedNettingProfiles': allowedNettingProfiles,
      'AllowedTradingSessions': allowedTradingSessions,
      'ContractOptionsTradingProfile': contractOptionsTradingProfile,
      //
      'ForceOpenDefaultValue': forceOpenDefaultValue,
      'IsMarginTradingAllowed': isMarginTradingAllowed,
      'IsVariationMarginEligible': isVariationMarginEligible,
      'ReduceExposureOnly': reduceExposureOnly,
      'SupportsAccountValueProtectionLimit':
          supportsAccountValueProtectionLimit,
      //
      'LegalAssetTypesAreIndicative': legalAssetTypesAreIndicative,
      'LegalAssetTypes': legalAssetTypes,
      //
      'MarginCalculationMethod': marginCalculationMethod,
      'MarginMonitoringMode': marginMonitoringMode,
      //
      'PartnerPlatformId': partnerPlatformId,
      //
      'PositionNettingMethod': positionNettingMethod,
      'PositionNettingMode': positionNettingMode,
      'PositionNettingProfile': positionNettingProfile,
    };
  }
}
