class SaxoAggregatedAmountModel {
  final String accountCurrency;
  final bool affectsBalance;
  final double amount;
  final double amountAccountCurrency;
  final String amountClass;
  final double amountClientCurrency;
  final String amountSubClass;
  final int amountTypeId;
  final String amountTypeName;
  final double amountUSD;
  final String? assetType;
  final String bookingAccountId;
  final String clientCurrency;
  final String costClass;
  final String costSubClass;
  final DateTime? date;
  final String? instrumentDescription;
  final String instrumentSubType;
  final int instrumentSubTypeId;
  final String? instrumentSymbol;
  final bool isManual;
  final int uic;
  final String? underlyingInstrumentAssetType;
  final String? underlyingInstrumentDescription;
  final String? underlyingInstrumentSubType;
  final String? underlyingInstrumentSymbol;
  final int? underlyingInstrumentUic;
  final String? underlyingType;
  //
  final Map<String, dynamic> json;

  SaxoAggregatedAmountModel({
    required this.accountCurrency,
    required this.affectsBalance,
    required this.amount,
    required this.amountAccountCurrency,
    required this.amountClass,
    required this.amountClientCurrency,
    required this.amountSubClass,
    required this.amountTypeId,
    required this.amountTypeName,
    required this.amountUSD,
    required this.assetType,
    required this.bookingAccountId,
    required this.clientCurrency,
    required this.costClass,
    required this.costSubClass,
    required this.date,
    required this.instrumentDescription,
    required this.instrumentSubType,
    required this.instrumentSubTypeId,
    required this.instrumentSymbol,
    required this.isManual,
    required this.uic,
    required this.underlyingInstrumentAssetType,
    required this.underlyingInstrumentDescription,
    required this.underlyingInstrumentSubType,
    required this.underlyingInstrumentSymbol,
    required this.underlyingInstrumentUic,
    required this.underlyingType,
    //
    required this.json,
  });

  factory SaxoAggregatedAmountModel.fromJson(Map<String, dynamic> json) {
    return SaxoAggregatedAmountModel(
      accountCurrency: json['AccountCurrency'],
      affectsBalance: json['AffectsBalance'],
      amount: json['Amount'],
      amountAccountCurrency: json['AmountAccountCurrency'],
      amountClass: json['AmountClass'],
      amountClientCurrency: json['AmountClientCurrency'],
      amountSubClass: json['AmountSubClass'],
      amountTypeId: json['AmountTypeId'],
      amountTypeName: json['AmountTypeName'],
      amountUSD: json['AmountUSD'],
      assetType: json['AssetType'],
      bookingAccountId: json['BookingAccountId'],
      clientCurrency: json['ClientCurrency'],
      costClass: json['CostClass'],
      costSubClass: json['CostSubClass'],
      date: DateTime.tryParse(json['Date'] ?? '')?.toLocal(),
      instrumentDescription: json['InstrumentDescription'],
      instrumentSubType: json['InstrumentSubType'],
      instrumentSubTypeId: json['InstrumentSubTypeId'],
      instrumentSymbol: json['InstrumentSymbol'],
      isManual: json['IsManual'],
      uic: json['Uic'],
      underlyingInstrumentAssetType: json['UnderlyingInstrumentAssetType'],
      underlyingInstrumentDescription: json['UnderlyingInstrumentDescription'],
      underlyingInstrumentSubType: json['UnderlyingInstrumentSubType'],
      underlyingInstrumentSymbol: json['UnderlyingInstrumentSymbol'],
      underlyingInstrumentUic: json['UnderlyingInstrumentUic'],
      underlyingType: json['UnderlyingType'],
      //
      json: json,
    );
  }
}
