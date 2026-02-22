import 'package:lasitrade/models/db/db_infoprice_model.dart';
import 'package:postgres/postgres.dart';

import 'package:lasitrade/utils/core_utils.dart';

class DBHistModel {
  final int histId;
  final int uic;

  double open;
  double high;
  double low;
  double close;
  int volume;

  final DateTime timeAt;

  bool infoPriced = false;

  DBHistModel({
    required this.histId,
    required this.uic,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.timeAt,
  });

  factory DBHistModel.fromJson(Map<String, dynamic> json) {
    return DBHistModel(
      histId: json['hist_id'],
      uic: json['uic'],
      //
      open: json['open'],
      high: json['high'],
      low: json['low'],
      close: json['close'],
      volume: json['volume'],
      //
      timeAt: DateTime.parse(json['time_at']).toLocal(),
    );
  }

  factory DBHistModel.fromRowResult(ResultRow row) {
    return DBHistModel(
      histId: row.elementAt(0) as int,
      uic: row.elementAt(1) as int,
      //
      open: row.elementAt(2) as double,
      high: row.elementAt(3) as double,
      low: row.elementAt(4) as double,
      close: row.elementAt(5) as double,
      volume: row.elementAt(6) as int,
      //
      timeAt: (row.elementAt(7) as DateTime).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hist_id': histId,
      'uic': uic,
      //
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'volume': volume,
      //
      'time_at': timeAt.toUtc().toIso8601String(),
    };
  }

  //~

  static DBHistModel? aggregateToday(List<DBHistModel> items) {
    final now = DateTime.now();
    items = items.where((it) => fnIsSameDay(it.timeAt, now)).toList();

    if (items.isEmpty) return null;

    items.sort((a, b) => a.timeAt.compareTo(b.timeAt));

    final first = items.first;
    final last = items.last;

    final totalVolume = items.fold<int>(0, (sum, e) => sum + e.volume);
    final high = items.map((e) => e.high).reduce((a, b) => a > b ? a : b);
    final low = items.map((e) => e.low).reduce((a, b) => a < b ? a : b);

    return DBHistModel(
      histId: 0,
      uic: first.uic,
      open: first.open,
      high: high,
      low: low,
      close: last.close,
      volume: totalVolume,
      timeAt: DateTime(
        first.timeAt.year,
        first.timeAt.month,
        first.timeAt.day,
      ),
    );
  }

  static DBHistModel? aggregateHistFromInfoPriceAfter(
    List<DBInfoPriceModel> items,
    DateTime afterTime,
  ) {
    items = items.where((it) => it.lastUpdatedAt.isAfter(afterTime)).toList();
    if (items.isEmpty) return null;

    items.sort((a, b) => a.lastUpdatedAt.compareTo(b.lastUpdatedAt));

    final first = items.first;
    final last = items.last;

    final high = items.map((e) => e.lastTraded).reduce((a, b) => a > b ? a : b);
    final low = items.map((e) => e.lastTraded).reduce((a, b) => a < b ? a : b);

    final it = DBHistModel(
      histId: 0,
      uic: first.uic,
      open: first.lastTraded,
      high: high,
      low: low,
      close: last.lastTraded,
      volume: 0,
      timeAt: last.lastUpdatedAt,
    );

    it.infoPriced = true;

    return it;
  }
}
