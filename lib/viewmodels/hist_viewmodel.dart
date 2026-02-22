import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/models/db/db_hist_model.dart';
import 'package:lasitrade/utils/core_utils.dart';

class HistViewModel extends ChangeNotifierExt {
  int notifLoadingInstrumentPerc = 0;
  String notifLoadingInstrumentHr = '';

  List<DBHistModel> currInstrumentHists5Min = [];
  List<DBHistModel> currInstrumentHists1Day = [];

  List<List<DBHistModel>> currInstrumentHists5MinN = [];

  List<DBHistModel> currInstrumentHistsN5Min(int inx) =>
      currInstrumentHists5MinN[inx];

  Future<void> init1() async {
    await histVM.syncInstrumentHists5Min(uic: instVM.currUic, month: 3);
    await histVM.syncInstrumentHists5MinN(month: 3);

    await histVM.syncInstrumentHists1Day(uic: instVM.currUic);
  }

  Future<void> syncInstrumentHists5Min({
    required int uic,
    required int month,
  }) async {
    currInstrumentHists5Min = await syncInstrumentHists5MinUic(
      uic: uic,
      month: month,
    );

    notify();
  }

  Future<void> syncInstrumentHists5MinN({
    required int month,
  }) async {
    for (var inx in [0, 1, 2, 3, 4]) {
      final uic = instVM.currUicN(inx);

      if (currInstrumentHists5MinN.elementAtOrNull(inx) == null) {
        currInstrumentHists5MinN.insert(inx, []);
      }

      currInstrumentHists5MinN[inx] = await syncInstrumentHists5MinUic(
        uic: uic,
        month: month,
      );
    }

    notify();
  }

  Future<List<DBHistModel>> syncInstrumentHists5MinUic({
    required int uic,
    required int month,
  }) async {
    final lastHist5min = await psqlServ.selectHistByUic(
      uic: uic,
      horizon: Horizon.m1,
      asc: false,
      limit: 1,
    );

    if (lastHist5min.isNotEmpty) {
      final lastHists5min = await instServ.getInstrumentHistorical(
        uic: uic,
        horizon: Horizon.m1,
        fromTime: lastHist5min[0].timeAt.add(const Duration(seconds: 1)),
      );

      if (lastHists5min.isNotEmpty) {
        await psqlServ.insertHists(hists: lastHists5min, horizon: Horizon.m1);
      }
    } else {
      final hists5min = await instServ.getInstrumentHistoricalFull(
        uic: uic,
        horizon: Horizon.m1,
        fromDt: DateTime(
          DateTime.now().year,
          DateTime.now().month - 2,
          1,
        ),
      );

      await psqlServ.insertHists(hists: hists5min, horizon: Horizon.m1);

      if (notifLoadingInstrumentPerc != 0) {
        notifLoadingInstrumentPerc = 0;
        notifLoadingInstrumentHr = '';
      }
    }

    return await psqlServ.selectHistByUic(
      uic: uic,
      horizon: Horizon.m1,
      month: month,
    );
  }

  Future<void> syncInstrumentHists1Day({
    required int uic,
  }) async {
    currInstrumentHists1Day = await syncInstrumentHists1DayUic(uic: uic);

    notify();
  }

  Future<List<DBHistModel>> syncInstrumentHists1DayUic({
    required int uic,
  }) async {
    final lastHist1day = await psqlServ.selectHistByUic(
      uic: uic,
      horizon: Horizon.d1,
      asc: false,
      limit: 1,
    );

    if (lastHist1day.isNotEmpty) {
      final lastInDay =
          DateTime.now().difference(lastHist1day[0].timeAt).inDays;
      if (lastInDay > 0) {
        final lastHists1day = await instServ.getInstrumentHistorical(
          uic: uic,
          horizon: Horizon.d1,
          fromTime: lastHist1day[0].timeAt,
        );

        await psqlServ.insertHists(hists: lastHists1day, horizon: Horizon.d1);
      }
    } else {
      final hists1day = await instServ.getInstrumentHistoricalFull(
        uic: uic,
        horizon: Horizon.d1,
      );

      await psqlServ.insertHists(hists: hists1day, horizon: Horizon.d1);

      if (notifLoadingInstrumentPerc != 0) {
        notifLoadingInstrumentPerc = 0;
        notifLoadingInstrumentHr = '';
      }
    }

    return await psqlServ.selectHistByUic(
      uic: uic,
      horizon: Horizon.d1,
    );
  }
}
