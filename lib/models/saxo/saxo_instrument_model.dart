class SaxoInstrumentModel {
  final int uic;
  final int groupId;
  final int? groupOptionRootId;
  //
  final String symbol0;
  final String symbol;
  final String description;
  //
  final String exchangeId;
  final String currencyCode;
  final String? issuerCountry;
  //
  final String assetType;
  final List<String> tradableAs;
  //
  final String? primaryListing;
  final String summaryType;
  //
  final bool? canParticipateInMultiLegOrder;

  SaxoInstrumentModel({
    required this.uic,
    required this.groupId,
    required this.groupOptionRootId,
    //
    required this.symbol0,
    required this.symbol,
    required this.description,
    //
    required this.exchangeId,
    required this.currencyCode,
    required this.issuerCountry,
    //
    required this.assetType,
    required this.tradableAs,
    //
    required this.primaryListing,
    required this.summaryType,
    //
    required this.canParticipateInMultiLegOrder,
  });

  factory SaxoInstrumentModel.fromJson(Map<String, dynamic> json) {
    return SaxoInstrumentModel(
        uic: json['Identifier'],
        groupId: json['GroupId'],
        groupOptionRootId: json['GroupOptionRootId'],
        //
        symbol0: json['Symbol'],
        symbol: json['Symbol'].replaceAll(':xnas', ''),
        description: json['Description'],
        //
        exchangeId: json['ExchangeId'],
        currencyCode: json['CurrencyCode'],
        issuerCountry: json['IssuerCountry'],
        //
        assetType: json['AssetType'],
        tradableAs: List<String>.from(json['TradableAs'] ?? []),
        //
        primaryListing: json['PrimaryListing'] != null
            ? (json['PrimaryListing'] as int).toString()
            : null,
        summaryType: json['SummaryType'],
        //
        canParticipateInMultiLegOrder: json['CanParticipateInMultiLegOrder']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Identifier': uic,
      'GroupId': groupId,
      'GroupOptionRootId': groupOptionRootId,
      //
      'Symbol': symbol0,
      'Description': description,
      //
      'ExchangeId': exchangeId,
      'CurrencyCode': currencyCode,
      'IssuerCountry': issuerCountry,
      //
      'AssetType': assetType,
      'TradableAs': tradableAs,
      //
      'PrimaryListing': int.tryParse(primaryListing ?? ''),
      'SummaryType': summaryType,
      //
      'CanParticipateInMultiLegOrder': canParticipateInMultiLegOrder,
    };
  }
}
