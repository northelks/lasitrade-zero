class SaxoClosedPositionModel {
  final String accountCurrency;
  final int accountCurrencyDecimals;
  final String accountId;
  final double amount;
  final double amountClose;
  final double amountOpen;
  final String assetType;
  final String clientCurrency;
  final int closePositionId;
  final double closePrice;
  final String closeType;
  final String exchangeDescription;
  final String instrumentCurrency;
  final String instrumentDescription;
  final String instrumentSymbol;
  final int openPositionId;
  final double openPrice;
  final double pnLAccountCurrency;
  final double pnLClientCurrency;
  final double pnLUSD;
  final double totalBookedOnClosingLegAccountCurrency;
  final double totalBookedOnClosingLegClientCurrency;
  final double totalBookedOnClosingLegUSD;
  final double totalBookedOnOpeningLegAccountCurrency;
  final double totalBookedOnOpeningLegClientCurrency;
  final double totalBookedOnOpeningLegUSD;
  final DateTime? tradeDate;
  final DateTime? tradeDateClose;
  final DateTime? tradeDateOpen;
  final String underlyingInstrumentDescription;
  final String underlyingInstrumentSymbol;
  //
  final Map<String, dynamic> json;

  SaxoClosedPositionModel({
    required this.accountCurrency,
    required this.accountCurrencyDecimals,
    required this.accountId,
    required this.amount,
    required this.amountClose,
    required this.amountOpen,
    required this.assetType,
    required this.clientCurrency,
    required this.closePositionId,
    required this.closePrice,
    required this.closeType,
    required this.exchangeDescription,
    required this.instrumentCurrency,
    required this.instrumentDescription,
    required this.instrumentSymbol,
    required this.openPositionId,
    required this.openPrice,
    required this.pnLAccountCurrency,
    required this.pnLClientCurrency,
    required this.pnLUSD,
    required this.totalBookedOnClosingLegAccountCurrency,
    required this.totalBookedOnClosingLegClientCurrency,
    required this.totalBookedOnClosingLegUSD,
    required this.totalBookedOnOpeningLegAccountCurrency,
    required this.totalBookedOnOpeningLegClientCurrency,
    required this.totalBookedOnOpeningLegUSD,
    required this.tradeDate,
    required this.tradeDateClose,
    required this.tradeDateOpen,
    required this.underlyingInstrumentDescription,
    required this.underlyingInstrumentSymbol,
    //
    required this.json,
  });

  String get symbol => instrumentSymbol.replaceAll(':xnas', '');

  factory SaxoClosedPositionModel.fromJson(Map<String, dynamic> json) {
    return SaxoClosedPositionModel(
      accountCurrency: json['AccountCurrency'],
      accountCurrencyDecimals: json['AccountCurrencyDecimals'],
      accountId: json['AccountId'],
      amount: json['Amount'],
      amountClose: json['AmountClose'],
      amountOpen: json['AmountOpen'],
      assetType: json['AssetType'],
      clientCurrency: json['ClientCurrency'],
      closePositionId: int.parse(json['ClosePositionId']),
      closePrice: json['ClosePrice'],
      closeType: json['CloseType'],
      exchangeDescription: json['ExchangeDescription'],
      instrumentCurrency: json['InstrumentCurrency'],
      instrumentDescription: json['InstrumentDescription'],
      instrumentSymbol: json['InstrumentSymbol'],
      openPositionId: int.parse(json['OpenPositionId']),
      openPrice: json['OpenPrice'],
      pnLAccountCurrency: json['PnLAccountCurrency'],
      pnLClientCurrency: json['PnLClientCurrency'],
      pnLUSD: json['PnLUSD'],
      totalBookedOnClosingLegAccountCurrency:
          json['TotalBookedOnClosingLegAccountCurrency'],
      totalBookedOnClosingLegClientCurrency:
          json['TotalBookedOnClosingLegClientCurrency'],
      totalBookedOnClosingLegUSD: json['TotalBookedOnClosingLegUSD'],
      totalBookedOnOpeningLegAccountCurrency:
          json['TotalBookedOnOpeningLegAccountCurrency'],
      totalBookedOnOpeningLegClientCurrency:
          json['TotalBookedOnOpeningLegClientCurrency'],
      totalBookedOnOpeningLegUSD: json['TotalBookedOnOpeningLegUSD'],
      tradeDate: DateTime.tryParse(json['TradeDate'] ?? '')?.toLocal(),
      tradeDateClose:
          DateTime.tryParse(json['TradeDateClose'] ?? '')?.toLocal(),
      tradeDateOpen: DateTime.tryParse(json['TradeDateOpen'] ?? '')?.toLocal(),
      underlyingInstrumentDescription: json['UnderlyingInstrumentDescription'],
      underlyingInstrumentSymbol: json['UnderlyingInstrumentSymbol'],
      //
      json: json,
    );
  }
}
