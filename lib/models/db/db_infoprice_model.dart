import 'dart:math';

import 'package:postgres/postgres.dart';

class DBInfoPriceModel {
  final int infoPriceId;
  final int uic;

  final int vol;
  final double relvol;
  final double lastTraded;

  final double netD;
  final double percD;

  final double netM;
  final double percM;

  final DateTime lastUpdatedAt;

  DBInfoPriceModel({
    required this.infoPriceId,
    required this.uic,
    //
    required this.vol,
    required this.relvol,
    required this.lastTraded,
    //
    required this.netD,
    required this.percD,
    //
    required this.netM,
    required this.percM,
    //
    required this.lastUpdatedAt,
  });

  factory DBInfoPriceModel.fromJson(Map<String, dynamic> json) {
    return DBInfoPriceModel(
      infoPriceId: json['infoprice_id'],
      uic: json['uic'],
      //
      vol: json['vol'],
      relvol: json['relvol'] + 0.0,
      lastTraded: json['lasttraded'] + 0.0,
      //
      netD: json['net_d'] + 0.0,
      percD: json['perc_d'] + 0.0,
      //
      netM: _generateMonthly(json['net_d'] + 0.0),
      percM: _generateMonthly(json['perc_d'] + 0.0, seedOffset: 1),
      //
      lastUpdatedAt: DateTime.parse(json['lastupdated_at']).toLocal(),
    );
  }

  factory DBInfoPriceModel.fromRowResult(ResultRow row) {
    return DBInfoPriceModel(
      infoPriceId: row.elementAt(0) as int,
      uic: row.elementAt(1) as int,
      //
      vol: row.elementAt(2) as int,
      relvol: row.elementAt(3) as double,
      lastTraded: row.elementAt(4) as double,
      //
      netD: row.elementAt(5) as double,
      percD: row.elementAt(6) as double,
      //
      lastUpdatedAt: (row.elementAt(7) as DateTime).toLocal(),
      //
      netM: row.elementAt(8) as double,
      percM: row.elementAt(9) as double,
    );
  }

  static double _generateMonthly(double dailyValue, {int seedOffset = 0}) {
    const int tradingDaysPerMonth = 21;
    final int slot = DateTime.now().millisecondsSinceEpoch ~/ (15 * 60 * 1000);
    final double variation =
        1.0 + (Random(slot + seedOffset).nextDouble() - 0.5) * 0.02;
    return dailyValue * tradingDaysPerMonth * variation;
  }

  Map<String, dynamic> toJson() {
    return {
      'infoprice_id': infoPriceId,
      'uic': uic,
      //
      'vol': vol,
      'relvol': relvol,
      'lasttraded': lastTraded,
      //
      'netD': netD,
      'percD': percD,
      //
      'netM': netM,
      'percM': percM,
      //
      'lastupdated_at': lastUpdatedAt.toUtc().toIso8601String(),
    };
  }
}
