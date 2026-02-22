abstract class SaxoInstrumentDataModel {
  final int uic;

  SaxoInstrumentDataModel({
    required this.uic,
  });
}

class SaxoInstrumentPriceModel extends SaxoInstrumentDataModel {
  final String assetType;
  final DateTime lastUpdated;
  final String priceSource;
  final SaxoInstrumentQuoteModel quote;
  final SaxoInstrumentDisplayAndFormatModel? displayAndFormat;

  SaxoInstrumentPriceModel({
    required super.uic,
    //
    required this.assetType,
    required this.lastUpdated,
    required this.priceSource,
    required this.quote,
    required this.displayAndFormat,
  });

  factory SaxoInstrumentPriceModel.fromJson(Map<String, dynamic> json) {
    json['Quote']['Uic'] = json['Uic'];
    json['Quote']['LastUpdated'] = json['LastUpdated'];

    return SaxoInstrumentPriceModel(
      uic: json['Uic'],
      assetType: json['AssetType'],
      lastUpdated: DateTime.parse(json['LastUpdated']).toLocal(),
      priceSource: json['PriceSource'],
      quote: SaxoInstrumentQuoteModel.fromJson(json['Quote']),
      displayAndFormat: json['DisplayAndFormat'] != null
          ? SaxoInstrumentDisplayAndFormatModel.fromJson(
              json['DisplayAndFormat'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Uic': uic,
      'AssetType': assetType,
      'LastUpdated': lastUpdated.toUtc().toIso8601String(),
      'PriceSource': priceSource,
      'Quote': quote.toJson(),
      'DisplayAndFormat': displayAndFormat?.toJson(),
    };
  }
}

class SaxoInstrumentQuoteModel extends SaxoInstrumentDataModel {
  final double? ask;
  final double? bid;
  final double? mid;
  //
  final double? askSize;
  final double? bidSize;
  //
  final int? delayedByMinutes;
  //
  final DateTime? lastUpdated;
  //
  final double? volume;

  SaxoInstrumentQuoteModel({
    required super.uic,
    //
    required this.ask,
    required this.bid,
    required this.mid,
    //
    required this.askSize,
    required this.bidSize,
    //
    required this.delayedByMinutes,
    //
    required this.lastUpdated,
    //
    this.volume,
  });

  factory SaxoInstrumentQuoteModel.fromJson(Map<String, dynamic> json) {
    return SaxoInstrumentQuoteModel(
      uic: json['Uic'],
      //
      ask: json['Ask'],
      bid: json['Bid'],
      mid: json['Mid'],
      //
      askSize: json['AskSize'],
      bidSize: json['BidSize'],
      //
      delayedByMinutes: json['DelayedByMinutes'],
      //
      lastUpdated: DateTime.tryParse(json['LastUpdated'] ?? '')?.toLocal(),
      //
      volume: json['Volume'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Uic': uic,
      //
      'Ask': ask,
      'Bid': bid,
      'Mid': mid,
      'AskSize': askSize,
      'BidSize': bidSize,
      'LastUpdated': lastUpdated?.toUtc().toIso8601String(),
    };
  }
}

class SaxoInstrumentFullQuoteModel extends SaxoInstrumentQuoteModel {
  final int? amount;
  //
  final String? errorCode;
  final String? marketState;
  final String? priceSource;
  final String? priceSourceType;
  final String? priceTypeAsk;
  final String? priceTypeBid;
  //
  final double? netChange;
  final double? percentChange;

  SaxoInstrumentFullQuoteModel({
    required super.uic,
    required super.ask,
    required super.bid,
    required super.askSize,
    required super.bidSize,
    required super.mid,
    required super.delayedByMinutes,
    required super.lastUpdated,
    //
    required this.amount,
    required this.errorCode,
    required this.marketState,
    required this.priceSource,
    required this.priceSourceType,
    required this.priceTypeAsk,
    required this.priceTypeBid,
    //
    required this.netChange,
    required this.percentChange,
  });

  factory SaxoInstrumentFullQuoteModel.fromJson(Map<String, dynamic> json) {
    return SaxoInstrumentFullQuoteModel(
      uic: json['Uic'],
      //
      ask: json['Ask'],
      bid: json['Bid'],
      mid: json['Mid'],
      askSize: json['AskSize'],
      bidSize: json['BidSize'],
      lastUpdated: DateTime.tryParse(json['LastUpdated'] ?? '')?.toLocal(),
      //
      amount: json['Amount'],
      delayedByMinutes: json['DelayedByMinutes'],
      errorCode: json['ErrorCode'],
      marketState: json['MarketState'],
      priceSource: json['PriceSource'],
      priceSourceType: json['PriceSourceType'],
      priceTypeAsk: json['PriceTypeAsk'],
      priceTypeBid: json['PriceTypeBid'],
      //
      netChange: json['NetChange'],
      percentChange: json['PercentChange'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'Uic': uic,
      //
      'Ask': ask,
      'Bid': bid,
      'Mid': mid,
      'AskSize': askSize,
      'BidSize': bidSize,
      'LastUpdated': lastUpdated?.toUtc().toIso8601String(),
      //
      'Amount': amount,
      'DelayedByMinutes': delayedByMinutes,
      'ErrorCode': errorCode,
      'MarketState': marketState,
      'PriceSource': priceSource,
      'PriceSourceType': priceSourceType,
      'PriceTypeAsk': priceTypeAsk,
      'PriceTypeBid': priceTypeBid,
      //
      'NetChange': netChange,
      'PercentChange': percentChange,
    };
  }
}

class SaxoInstrumentDisplayAndFormatModel {
  final int? uic;
  final String currency;
  final int decimals;
  final String description;
  final String format;
  final int? orderDecimals;
  final String symbol;

  SaxoInstrumentDisplayAndFormatModel({
    required this.uic,
    required this.currency,
    required this.decimals,
    required this.description,
    required this.format,
    required this.orderDecimals,
    required this.symbol,
  });

  factory SaxoInstrumentDisplayAndFormatModel.fromJson(
      Map<String, dynamic> json) {
    return SaxoInstrumentDisplayAndFormatModel(
      uic: json['Uic'],
      currency: json['Currency'],
      decimals: json['Decimals'],
      description: json['Description'],
      format: json['Format'],
      orderDecimals: json['OrderDecimals'],
      symbol: json['Symbol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Uic': uic,
      'Currency': currency,
      'Decimals': decimals,
      'Description': description,
      'Format': format,
      'OrderDecimals': format,
      'Symbol': symbol
    };
  }
}

class SaxoInstrumentChartInfoModel {
  final int delayedByMinutes;
  final String exchangeId;
  final DateTime firstSampleTime;
  final int horizon;
  final DateTime? maxTradeDay;
  final DateTime? minTradeDay;

  SaxoInstrumentChartInfoModel({
    required this.delayedByMinutes,
    required this.exchangeId,
    required this.firstSampleTime,
    required this.horizon,
    required this.maxTradeDay,
    required this.minTradeDay,
  });

  factory SaxoInstrumentChartInfoModel.fromJson(Map<String, dynamic> json) {
    return SaxoInstrumentChartInfoModel(
      delayedByMinutes: json['DelayedByMinutes'],
      exchangeId: json['ExchangeId'],
      firstSampleTime: DateTime.parse(json['FirstSampleTime']).toLocal(),
      horizon: json['Horizon'],
      maxTradeDay: DateTime.tryParse(json['MaxTradeDay'] ?? '')?.toLocal(),
      minTradeDay: DateTime.tryParse(json['MinTradeDay'] ?? '')?.toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DelayedByMinutes': delayedByMinutes,
      'ExchangeId': exchangeId,
      'FirstSampleTime': firstSampleTime.toUtc().toIso8601String(),
      'Horizon': horizon,
      'MaxTradeDay': maxTradeDay?.toUtc().toIso8601String(),
      'MinTradeDay': minTradeDay?.toUtc().toIso8601String(),
    };
  }
}

class SaxoInstrumentHistoricalModel {
  final SaxoInstrumentChartInfoModel chartInfo;
  final List<SaxoInstrumentOHLCModel> data;
  final int dataVersion;
  final SaxoInstrumentDisplayAndFormatModel? displayAndFormat;

  SaxoInstrumentHistoricalModel({
    required this.chartInfo,
    required this.data,
    required this.dataVersion,
    required this.displayAndFormat,
  });

  factory SaxoInstrumentHistoricalModel.fromJson(
      int uic, Map<String, dynamic> json) {
    return SaxoInstrumentHistoricalModel(
      chartInfo: SaxoInstrumentChartInfoModel.fromJson(json['ChartInfo']),
      data: List<Map<String, dynamic>>.from(json['Data']).map((it) {
        return SaxoInstrumentOHLCModel.fromJson(uic, it);
      }).toList(),
      dataVersion: json['DataVersion'],
      displayAndFormat: json['DisplayAndFormat'] != null
          ? SaxoInstrumentDisplayAndFormatModel.fromJson(
              json['DisplayAndFormat'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ChartInfo': chartInfo,
      'Data': data.map((it) => it.toJson()).toList(),
      'DataVersion': dataVersion,
      'DisplayAndFormat': displayAndFormat?.toJson(),
    };
  }
}

abstract class SaxoInstrumentHistoryModel {
  Map<String, dynamic> toJson();
}

class SaxoInstrumentOHLCModel extends SaxoInstrumentHistoryModel {
  final int uic;
  double close;
  final double high;
  final double low;
  final double open;
  final num interest;
  final num volume;
  final DateTime time;

  bool? ext;
  double? extRelVol;
  double? extVol;

  SaxoInstrumentOHLCModel({
    required this.uic,
    required this.close,
    required this.high,
    required this.low,
    required this.open,
    required this.interest,
    required this.volume,
    required this.time,
    this.ext,
    this.extRelVol,
    this.extVol,
  });

  factory SaxoInstrumentOHLCModel.fromJson(int uic, Map<String, dynamic> json) {
    DateTime time = DateTime.parse(json['Time']);
    if (time.hour != 0 && time.minute != 0) {
      time = time.toLocal();
    }

    return SaxoInstrumentOHLCModel(
      uic: uic,
      close: json['Close'] + 0.0,
      high: json['High'] + 0.0,
      low: json['Low'] + 0.0,
      open: json['Open'] + 0.0,
      interest: json['Interest'],
      volume: json['Volume'],
      time: time,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'Uic': uic,
      'Close': close,
      'High': high,
      'Low': low,
      'Open': open,
      'Interest': interest,
      'Volume': volume,
      'Time': time.toUtc().toIso8601String(),
    };
  }

  @override
  String toString() {
    return '[${time.toIso8601String()}] uic: $uic, c: $close, h: $high, l: $low, o: $open, i: $interest, v: $volume';
  }
}

class SaxoInstrumentOOHHLLCCModel extends SaxoInstrumentHistoryModel {
  final int uic;
  final double closeAsk;
  final double closeBid;
  final double highAsk;
  final double highBid;
  final double lowAsk;
  final double lowBid;
  final double openAsk;
  final double openBid;
  final DateTime time;

  SaxoInstrumentOOHHLLCCModel({
    required this.uic,
    required this.closeAsk,
    required this.closeBid,
    required this.highAsk,
    required this.highBid,
    required this.lowAsk,
    required this.lowBid,
    required this.openAsk,
    required this.openBid,
    required this.time,
  });

  factory SaxoInstrumentOOHHLLCCModel.fromJson(Map<String, dynamic> json) {
    return SaxoInstrumentOOHHLLCCModel(
      uic: json['uic'],
      closeAsk: json['CloseAsk'],
      closeBid: json['CloseBid'],
      highAsk: json['HighAsk'],
      highBid: json['HighBid'],
      lowAsk: json['LowAsk'],
      lowBid: json['LowBid'],
      openAsk: json['OpenAsk'],
      openBid: json['OpenBid'],
      time: DateTime.parse(json['Time']).toLocal(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'Uic': uic,
      'CloseAsk': closeAsk,
      'CloseBid': closeBid,
      'HighAsk': highAsk,
      'HighBid': highBid,
      'LowAsk': lowAsk,
      'LowBid': lowBid,
      'OpenAsk': openAsk,
      'OpenBid': openBid,
      'Time': time.toUtc().toIso8601String(),
    };
  }

  @override
  String toString() {
    return '[${time.toUtc().toIso8601String()}] uic: $uic, c: $closeAsk/$closeBid, h: $highAsk/$highBid, l: $lowAsk/$lowBid, o: $openAsk/$openBid';
  }
}

class SaxoInstrumentCommissionsModel extends SaxoInstrumentDataModel {
  final String currency;

  SaxoInstrumentCommissionsModel({
    required super.uic,
    required this.currency,
  });

  factory SaxoInstrumentCommissionsModel.fromJson(Map<String, dynamic> json) {
    return SaxoInstrumentCommissionsModel(
      uic: json['Uic'],
      //
      currency: json['Currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Uic': uic,
      'Currency': currency,
    };
  }
}
