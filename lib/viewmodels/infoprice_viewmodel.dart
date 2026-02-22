import 'package:collection/collection.dart';

import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/models/db/db_infoprice_model.dart';
import 'package:lasitrade/utils/core_utils.dart';

class InfoPriceViewModel extends ChangeNotifierExt {
  List<DBInfoPriceModel> _infoPrices = [];
  List<DBInfoPriceModel> get infoPrices => _infoPrices;

  List<DBInfoPriceModel> get infoPricesPinned {
    return _infoPrices.where((it) {
      return instVM.instruments.firstWhere((it0) => it0.uic == it.uic).pinned;
    }).toList();
  }

  List<DBInfoPriceModel> get infoPricesScreenered {
    return _infoPrices.where((it) {
      return instVM.instruments
          .firstWhere((it0) => it0.uic == it.uic)
          .screenered;
    }).toList();
  }

  DBInfoPriceModel? get curreInfoPrice =>
      infoPrices.firstWhereOrNull((it) => it.uic == instVM.currUic);

  DBInfoPriceModel? infoPriceOf(int uic) =>
      _infoPrices.firstWhereOrNull((it) => it.uic == uic);

  List<DBInfoPriceModel> infoPricesAfter(int uic, DateTime afterTime) {
    return _infoPrices
        .where((it) => it.uic == uic && it.lastUpdatedAt.isAfter(afterTime))
        .toList();
  }

  DBInfoPriceModel? infoPriceScreenerOf(int uic) =>
      _infoPrices.firstWhereOrNull((it) =>
          it.uic == uic &&
          it.lastTraded >= appVM.screenerPriceFrom &&
          it.lastTraded <= appVM.screenerPriceTo);

  int get latestInfoPriceSecAgo {
    List<DBInfoPriceModel> list = List<DBInfoPriceModel>.from(_infoPrices);
    list.sort((a, b) => b.lastUpdatedAt.compareTo(a.lastUpdatedAt));

    if (list.isEmpty) return -1;

    return DateTime.now().difference(list.first.lastUpdatedAt).inSeconds;
  }

  //~

  List<(String, String)> infoPriceSortBy = [('netM', 'desc')];

  List<DBInfoPriceModel> infoPricesOfWatchlist(String wachlist) {
    if (wachlist == 'On Desk') {
      return infoPricesScreenered;
    }

    if (wachlist == 'Watched') {
      return infoPrices;
    }

    final watchlistId = instVM.watchlistOf(wachlist).watchlistId;
    final watchlisted = instVM.instruments
        .where((it) => it.watchlistIds.contains(watchlistId))
        .toList();
    final watchlistedUics = watchlisted.map((it) => it.uic).toList();

    final infoPricesWatchlisted = infoPrices.where((it) {
      final fnd = watchlistedUics.contains(it.uic);
      if (fnd) watchlisted.removeWhere((itt) => itt.uic == it.uic);

      return fnd;
    }).toList();

    for (var it in watchlisted) {
      infoPricesWatchlisted.add(DBInfoPriceModel(
        infoPriceId: 0,
        uic: it.uic,
        vol: -0,
        relvol: -0.0,
        lastTraded: -0.0,
        netD: -0.0,
        percD: -0.0,
        netM: -0.0,
        percM: -0.0,
        lastUpdatedAt: DateTime(1900),
      ));
    }

    return infoPricesWatchlisted;
  }

  //~

  Future<void> init1() async {
    await psqlServ.deleteAllNotLatest1DaysInfoPrices();
    await syncInfoPrices();

    notify();
  }

  //+ infoprices

  Future<void> syncInfoPrices() async {
    List<Map<String, dynamic>> infoPriceDatas = [];

    final uicsAll = instVM.instruments.map((e) => e.uic).toList();

    // int count = 0;
    while (uicsAll.isNotEmpty) {
      // count += 1;

      final uics230 = uicsAll.take(230).toList();
      uicsAll.removeRange(0, uicsAll.length >= 230 ? 230 : uicsAll.length);

      List<Map<String, dynamic>> infoPrices230 = [];

      try {
        infoPrices230 = await instServ.getInstrumentsLastTraded(
          uics: uics230,
        );
      } on AppError catch (e) {
        if (e.code == '429') {
          final resetSec = int.tryParse(e.message ?? '') ?? 3;
          await Future.delayed(Duration(seconds: resetSec));

          infoPrices230 = await instServ.getInstrumentsLastTraded(
            uics: uics230,
          );
        }
      }

      if (infoPrices230.isEmpty) continue;

      for (var it in infoPrices230) {
        final Map<String, dynamic> infoPriceData = {
          'infoprice_id': 0,
          'uic': null,
          'vol': null,
          'relvol': null,
          'lasttraded': null,
          'net_d': null,
          'perc_d': null,
          //
          'lastupdated_at': null,
        };

        if (it.containsKey('Uic')) {
          infoPriceData['uic'] = it['Uic'];
        }

        if (it.containsKey('LastUpdated')) {
          infoPriceData['lastupdated_at'] = it['LastUpdated'];
        }

        if (it.containsKey('PriceInfo')) {
          infoPriceData['net_d'] = it['PriceInfo']['NetChange'] ?? 0.0;
          infoPriceData['perc_d'] = it['PriceInfo']['PercentChange'] ?? 0.0;
        }

        if (it.containsKey('PriceInfoDetails')) {
          infoPriceData['vol'] = it['PriceInfoDetails']['Volume'] ?? 0;
          infoPriceData['lasttraded'] =
              it['PriceInfoDetails']['LastTraded'] ?? 0.0;
        }

        if (it.containsKey('InstrumentPriceDetails')) {
          infoPriceData['relvol'] =
              it['InstrumentPriceDetails']['RelativeVolume'] ?? 0.0;
        }

        bool allKeysFilled = infoPriceData.values.every((it) => it != null);
        if (allKeysFilled &&
            infoPriceData['perc_d'] != 0 &&
            infoPriceData['vol'] != 0) {
          infoPriceDatas.add(infoPriceData);
        }
      }
    }

    await psqlServ.insertInfoPrices(infoPriceDatas);

    _infoPrices = await psqlServ.selectLatestInfoPrices();
  }
}
