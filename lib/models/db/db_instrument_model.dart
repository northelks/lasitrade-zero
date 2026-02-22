import 'package:postgres/postgres.dart';

import 'package:lasitrade/getit.dart';

class DBInstrumentModel {
  final int uic;
  final String symbol;
  final String name;
  DateTime? viewedAt;
  List<String> watchlistIds;
  final DateTime createdAt;

  DBInstrumentModel({
    required this.uic,
    required this.symbol,
    required this.name,
    required this.viewedAt,
    this.watchlistIds = const [],
    required this.createdAt,
  });

  bool get pinned =>
      watchlistIds.contains(instVM.watchlistPinned().watchlistId);
  bool get watched => infoPriceVM.infoPriceOf(uic) != null;
  bool get screenered => infoPriceVM.infoPriceScreenerOf(uic) != null;

  factory DBInstrumentModel.fromRowResult(ResultRow row) {
    List<String> watchlistIds = [];
    if (row.elementAt(4) != null) {
      if (row.elementAt(4) is List) {
        if ((row.elementAt(4) as List).isNotEmpty) {
          watchlistIds = List<String>.from(row.elementAt(4) as List<String>);
        }
      }
    }

    return DBInstrumentModel(
      uic: row.elementAt(0) as int,
      symbol: row.elementAt(1) as String,
      name: row.elementAt(2) as String,
      viewedAt: (row.elementAt(3) as DateTime?)?.toLocal(),
      watchlistIds: watchlistIds,
      createdAt: (row.elementAt(5) as DateTime).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uic': uic,
      'symbol': symbol,
      'name': name,
      'viewed_at': viewedAt,
      'watchlist_ids': watchlistIds,
      'created_at': createdAt,
    };
  }
}
