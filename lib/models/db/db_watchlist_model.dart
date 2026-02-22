import 'package:postgres/postgres.dart';

mixin DBWatchlistModelExt {
  int count = 0;
}

class DBWatchlistModel with DBWatchlistModelExt {
  final String watchlistId;
  final String name;

  DBWatchlistModel({
    required this.watchlistId,
    required this.name,
  });

  factory DBWatchlistModel.fromJson(Map<String, dynamic> json) {
    return DBWatchlistModel(
      watchlistId: json['watchlist_id'],
      name: json['name'],
    );
  }

  factory DBWatchlistModel.fromRowResult(ResultRow row) {
    return DBWatchlistModel(
      watchlistId: row.elementAt(0) as String,
      name: row.elementAt(1) as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'watchlist_id': watchlistId,
      'name': name,
    };
  }
}
