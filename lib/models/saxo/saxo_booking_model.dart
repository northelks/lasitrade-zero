class SaxoBookingModel {
  final String accountCurrency;
  final String accountId;
  final double amount;
  final double amountAccountCurrency;
  final String amountClass;
  final double amountClientCurrency;
  final String amountSubClass;
  final double amountUSD;
  final String? assetType;
  final int bkAmountId;
  final String bkAmountType;
  final int bkAmountTypeId;
  final int caMasterRecordId;
  final String clientCurrency;
  final double conversionRate;
  final double conversionRateAccountCurrency;
  final double conversionRateClientCurrency;
  final double conversionRateUSD;
  final String costClass;
  final String costSubClass;
  final String currency;
  final DateTime? date;
  final String? instrumentDescription;
  final String instrumentSubType;
  final String? instrumentSymbol;
  final int relatedPositionId;
  final int relatedTradeId;
  final int uic;
  final String? underlyingInstrumentAssetType;
  final String? underlyingInstrumentDescription;
  final String? underlyingInstrumentSectorName;
  final String? underlyingInstrumentSubType;
  final String? underlyingInstrumentSymbol;
  final int? underlyingInstrumentUic;
  final String? underlyingType;
  final DateTime? valueDate;
  //
  final Map<String, dynamic> json;

  SaxoBookingModel({
    required this.accountCurrency,
    required this.accountId,
    required this.amount,
    required this.amountAccountCurrency,
    required this.amountClass,
    required this.amountClientCurrency,
    required this.amountSubClass,
    required this.amountUSD,
    required this.assetType,
    required this.bkAmountId,
    required this.bkAmountType,
    required this.bkAmountTypeId,
    required this.caMasterRecordId,
    required this.clientCurrency,
    required this.conversionRate,
    required this.conversionRateAccountCurrency,
    required this.conversionRateClientCurrency,
    required this.conversionRateUSD,
    required this.costClass,
    required this.costSubClass,
    required this.currency,
    required this.date,
    required this.instrumentDescription,
    required this.instrumentSubType,
    required this.instrumentSymbol,
    required this.relatedPositionId,
    required this.relatedTradeId,
    required this.uic,
    required this.underlyingInstrumentAssetType,
    required this.underlyingInstrumentDescription,
    required this.underlyingInstrumentSectorName,
    required this.underlyingInstrumentSubType,
    required this.underlyingInstrumentSymbol,
    required this.underlyingInstrumentUic,
    required this.underlyingType,
    required this.valueDate,
    //
    required this.json,
  });

  String? get symbol => instrumentSymbol?.replaceAll(':xnas', '');

  factory SaxoBookingModel.fromJson(Map<String, dynamic> json) {
    return SaxoBookingModel(
      accountCurrency: json['AccountCurrency'],
      accountId: json['AccountId'],
      amount: json['Amount'],
      amountAccountCurrency: json['AmountAccountCurrency'],
      amountClass: json['AmountClass'],
      amountClientCurrency: json['AmountClientCurrency'],
      amountSubClass: json['AmountSubClass'],
      amountUSD: json['AmountUSD'],
      assetType: json['AssetType'],
      bkAmountId: int.parse(json['BkAmountId']),
      bkAmountType: json['BkAmountType'],
      bkAmountTypeId: int.parse(json['BkAmountTypeId']),
      caMasterRecordId: int.parse(json['CaMasterRecordId']),
      clientCurrency: json['ClientCurrency'],
      conversionRate: json['ConversionRate'],
      conversionRateAccountCurrency: json['ConversionRateAccountCurrency'],
      conversionRateClientCurrency: json['ConversionRateClientCurrency'],
      conversionRateUSD: json['ConversionRateUSD'],
      costClass: json['CostClass'],
      costSubClass: json['CostSubClass'],
      currency: json['Currency'],
      date: DateTime.tryParse(json['Date'] ?? '')?.toLocal(),
      instrumentDescription: json['InstrumentDescription'],
      instrumentSubType: json['InstrumentSubType'],
      instrumentSymbol: json['InstrumentSymbol'],
      relatedPositionId: int.parse(json['RelatedPositionId']),
      relatedTradeId: int.parse(json['RelatedTradeId']),
      uic: json['Uic'],
      underlyingInstrumentAssetType: json['UnderlyingInstrumentAssetType'],
      underlyingInstrumentDescription: json['UnderlyingInstrumentDescription'],
      underlyingInstrumentSectorName: json['UnderlyingInstrumentSectorName'],
      underlyingInstrumentSubType: json['UnderlyingInstrumentSubType'],
      underlyingInstrumentSymbol: json['UnderlyingInstrumentSymbol'],
      underlyingInstrumentUic: json['UnderlyingInstrumentUic'],
      underlyingType: json['UnderlyingType'],
      valueDate: DateTime.tryParse(json['ValueDate'] ?? '')?.toLocal(),
      //
      json: json,
    );
  }
}
