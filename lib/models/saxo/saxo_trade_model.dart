class SaxoTradeModel {
  final String accountCurrency;
  final int accountCurrencyDecimals;
  final String accountId;
  final DateTime? adjustedTradeDate;
  final double amount;
  final String assetType;
  final double bookedAmountAccountCurrency;
  final double bookedAmountClientCurrency;
  final double bookedAmountUSD;
  final String clientCurrency;
  final String direction;
  final String exchangeDescription;
  final double financingLevel;
  final String instrumentCategoryCode;
  final int instrumentCurrencyDecimal;
  final String instrumentDescription;
  final String instrumentSymbol;
  final String issuerName;
  final int orderId;
  final double price;
  final double residualValue;
  final double spreadCostAccountCurrency;
  final double spreadCostClientCurrency;
  final double spreadCostUSD;
  final double stopLoss;
  final double strike;
  final double strike2;
  final int toolId;
  final String toOpenOrClose;
  final bool tradeBarrierEventStatus;
  final DateTime? tradeDate;
  final double tradedValue;
  final String tradeEventType;
  final DateTime? tradeExecutionTime;
  final int tradeId;
  final String tradeType;
  final int uic;
  final String underlyingInstrumentDescription;
  final String underlyingInstrumentSymbol;
  final DateTime? valueDate;
  final String venue;
  //
  final Map<String, dynamic> json;

  SaxoTradeModel({
    required this.accountCurrency,
    required this.accountCurrencyDecimals,
    required this.accountId,
    required this.adjustedTradeDate,
    required this.amount,
    required this.assetType,
    required this.bookedAmountAccountCurrency,
    required this.bookedAmountClientCurrency,
    required this.bookedAmountUSD,
    required this.clientCurrency,
    required this.direction,
    required this.exchangeDescription,
    required this.financingLevel,
    required this.instrumentCategoryCode,
    required this.instrumentCurrencyDecimal,
    required this.instrumentDescription,
    required this.instrumentSymbol,
    required this.issuerName,
    required this.orderId,
    required this.price,
    required this.residualValue,
    required this.spreadCostAccountCurrency,
    required this.spreadCostClientCurrency,
    required this.spreadCostUSD,
    required this.stopLoss,
    required this.strike,
    required this.strike2,
    required this.toolId,
    required this.toOpenOrClose,
    required this.tradeBarrierEventStatus,
    required this.tradeDate,
    required this.tradedValue,
    required this.tradeEventType,
    required this.tradeExecutionTime,
    required this.tradeId,
    required this.tradeType,
    required this.uic,
    required this.underlyingInstrumentDescription,
    required this.underlyingInstrumentSymbol,
    required this.valueDate,
    required this.venue,
    //
    required this.json,
  });

  factory SaxoTradeModel.fromJson(Map<String, dynamic> json) {
    return SaxoTradeModel(
      accountCurrency: json['AccountCurrency'],
      accountCurrencyDecimals: json['AccountCurrencyDecimals'],
      accountId: json['AccountId'],
      adjustedTradeDate:
          DateTime.tryParse(json['AdjustedTradeDate'] ?? '')?.toLocal(),
      amount: json['Amount'],
      assetType: json['AssetType'],
      bookedAmountAccountCurrency: json['BookedAmountAccountCurrency'],
      bookedAmountClientCurrency: json['BookedAmountClientCurrency'],
      bookedAmountUSD: json['BookedAmountUSD'],
      clientCurrency: json['ClientCurrency'],
      direction: json['Direction'],
      exchangeDescription: json['ExchangeDescription'],
      financingLevel: json['FinancingLevel'],
      instrumentCategoryCode: json['InstrumentCategoryCode'],
      instrumentCurrencyDecimal: json['InstrumentCurrencyDecimal'],
      instrumentDescription: json['InstrumentDescription'],
      instrumentSymbol: json['InstrumentSymbol'],
      issuerName: json['IssuerName'],
      orderId: int.parse(json['OrderId']),
      price: json['Price'],
      residualValue: json['ResidualValue'],
      spreadCostAccountCurrency: json['SpreadCostAccountCurrency'],
      spreadCostClientCurrency: json['SpreadCostClientCurrency'],
      spreadCostUSD: json['SpreadCostUSD'],
      stopLoss: json['StopLoss'],
      strike: json['Strike'],
      strike2: json['Strike2'],
      toolId: int.parse(json['ToolId']),
      toOpenOrClose: json['ToOpenOrClose'],
      tradeBarrierEventStatus: json['TradeBarrierEventStatus'],
      tradeDate: DateTime.tryParse(json['TradeDate'] ?? '')?.toLocal(),
      tradedValue: json['TradedValue'],
      tradeEventType: json['TradeEventType'],
      tradeExecutionTime:
          DateTime.tryParse(json['TradeExecutionTime'] ?? '')?.toLocal(),
      tradeId: int.parse(json['TradeId']),
      tradeType: json['TradeType'],
      uic: json['Uic'],
      underlyingInstrumentDescription: json['UnderlyingInstrumentDescription'],
      underlyingInstrumentSymbol: json['UnderlyingInstrumentSymbol'],
      valueDate: DateTime.tryParse(json['ValueDate'] ?? '')?.toLocal(),
      venue: json['Venue'],
      //
      json: json,
    );
  }
}
