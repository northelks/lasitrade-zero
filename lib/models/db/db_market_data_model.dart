import 'package:postgres/postgres.dart';

class DBMarketDataModel {
  final int marketDataId;
  final int uic;

  final double price;
  final double priceNet;
  final double pricePerc;
  final double marketCap;
  final double volume;
  final double volumePer;
  final double shsOutstand;
  final double shsFloat;
  final double shsFloatPer;
  final double shortInterest;
  final double shortRatio;
  final double shortFloat;

  final DateTime timeAt;

  DBMarketDataModel({
    required this.marketDataId,
    required this.uic,
    required this.price,
    required this.priceNet,
    required this.pricePerc,
    required this.marketCap,
    required this.volume,
    required this.volumePer,
    required this.shsOutstand,
    required this.shsFloat,
    required this.shsFloatPer,
    required this.shortInterest,
    required this.shortRatio,
    required this.shortFloat,
    required this.timeAt,
  });

  factory DBMarketDataModel.fromRowResult(ResultRow row) {
    return DBMarketDataModel(
      marketDataId: row.elementAt(0) as int,
      uic: row.elementAt(1) as int,
      //
      price: row.elementAt(2) as double,
      priceNet: row.elementAt(3) as double,
      pricePerc: row.elementAt(4) as double,
      marketCap: row.elementAt(5) as double,
      volume: row.elementAt(6) as double,
      volumePer: row.elementAt(7) as double,
      shsOutstand: row.elementAt(8) as double,
      shsFloat: row.elementAt(9) as double,
      shsFloatPer: row.elementAt(10) as double,
      shortInterest: row.elementAt(11) as double,
      shortRatio: row.elementAt(12) as double,
      shortFloat: row.elementAt(13) as double,
      //
      timeAt: (row.elementAt(14) as DateTime).toLocal(),
    );
  }

  factory DBMarketDataModel.fromScrapeJson(Map<String, dynamic> json, int uic) {
    return DBMarketDataModel(
      marketDataId: -1,
      uic: uic,
      //
      price: json['price'] ?? 0.0,
      priceNet: json['price_net'] ?? 0.0,
      pricePerc: json['price_perc'] ?? 0.0,
      marketCap: json['market_cap'] ?? 0.0,
      volume: json['volume'] ?? 0.0,
      volumePer: json['volume_per'] ?? 0.0,
      shsOutstand: json['shs_outstand'] ?? 0.0,
      shsFloat: json['shs_float'] ?? 0.0,
      shsFloatPer: json['shs_float_per'] ?? 0.0,
      shortInterest: json['short_interest'] ?? 0.0,
      shortRatio: json['short_ratio'] ?? 0.0,
      shortFloat: json['short_float'] ?? 0.0,
      //
      timeAt: DateTime.now(),
    );
  }
}
