import 'package:dio/dio.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/models/saxo/saxo_exchange_model.dart';
import 'package:lasitrade/models/saxo/saxo_instrument_details_model.dart';
import 'package:lasitrade/models/saxo/saxo_instrument_model.dart';
import 'package:lasitrade/models/saxo/saxo_instrument_data_model.dart';
import 'package:lasitrade/utils/core_utils.dart';

class InstrumentService {
  Future<void> init() async {
    //
  }

  Future<List<SaxoExchangeModel>> getExchanges({
    int? limit = 1000,
  }) async {
    final res = await dioCl.get('/ref/v1/exchanges?\$top=$limit');
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(res.data['Data'])
          .map((it) => SaxoExchangeModel.fromJson(it))
          .toList();
    }

    return [];
  }

  Future<SaxoExchangeModel> getExchangeNasdaq() async {
    final res = await dioCl.get('/ref/v1/exchanges/NASDAQ');
    return SaxoExchangeModel.fromJson(res.data);
  }

  Future<List<SaxoInstrumentModel>> findInstrument({
    String? query,
    String? exchangeId,
    String? assetType,
    int? limit = 100,
    bool? includeNonTradable = false,
    bool? doNext = false,
    // String? issuerCountry = 'US',
  }) async {
    List<SaxoInstrumentModel> result = [];

    if ((limit ?? 0) > 1000) {
      limit = 1000;
    }

    String url =
        '/ref/v1/instruments?\$top=$limit&AccountKey=${appVM.accountKey}';

    if (query != null) {
      url += '&Keywords=$query';
    }

    if (exchangeId != null) {
      url += '&ExchangeId=$exchangeId';
    }

    if (assetType != null) {
      url += '&AssetTypes=$assetType';
    }

    // if (issuerCountry != null) {
    //   url += '&IssuerCountry=$issuerCountry';
    // }

    url += '&IncludeNonTradable=$includeNonTradable';

    final res = await dioCl.get(url);
    if (res.statusCode == 200) {
      result.addAll(List<Map<String, dynamic>>.from(res.data['Data'])
          .map((it) => SaxoInstrumentModel.fromJson(it))
          .toList());
    }

    Future<dynamic> fnNext(url) async {
      final res = await dioCl.get(url);
      if (res.statusCode == 200) {
        result.addAll(List<Map<String, dynamic>>.from(res.data['Data'])
            .map((it) => SaxoInstrumentModel.fromJson(it))
            .toList());

        if ((res.data as Map).containsKey('__next')) {
          await Future.delayed(Duration(milliseconds: 100));
          await fnNext(res.data['__next']);
        }
      }
    }

    if ((doNext ?? false) && (res.data as Map).containsKey('__next')) {
      await Future.delayed(Duration(milliseconds: 100));
      await fnNext(res.data['__next']);
    }

    return result;
  }

  Future<SaxoInstrumentDetailsModel?> getInstrumentDetails({
    required int uic,
    String? assetType,
    bool contractOption = false,
    bool futures = false,
  }) async {
    if (!contractOption && !futures && assetType == null) {
      assert(false);
    }

    String url = '/ref/v1/instruments/details/$uic/$assetType';

    if (contractOption) {
      url = '/ref/v1/instruments/contractoptionspaces/$uic';
    } else if (futures) {
      url = '/ref/v1/instruments/futuresspaces/$uic';
    }

    final res = await dioCl.get(url);
    if (res.statusCode == 200) {
      return SaxoInstrumentDetailsModel.fromJson(res.data);
    }

    return null;
  }

  Future<SaxoInstrumentPriceModel?> getInstrumentPrice({
    required int uic,
    String assetType = 'Stock',
    int? amount,
  }) async {
    String url =
        '/trade/v1/infoprices?AccountKey=${appVM.accountKey}&Uic=$uic&AssetType=$assetType&FieldGroups=DisplayAndFormat,InstrumentPriceDetails,MarketDepth,PriceInfo,PriceInfoDetails,Quote';

    if (amount != null) {
      url += '&Amount=$amount';
    }

    final res = await dioCl.get(url);
    if (res.statusCode == 200) {
      return SaxoInstrumentPriceModel.fromJson(res.data);
    }

    return null;
  }

  int? resetSec;
  Future<List<Map<String, dynamic>>> getInstrumentsLastTraded({
    required List<int> uics,
  }) async {
    try {
      String url =
          '/trade/v1/infoprices/list?AccountKey=${appVM.accountKey}&Uics=${uics.join(',')}&AssetType=Stock&FieldGroups=PriceInfo,PriceInfoDetails,InstrumentPriceDetails';

      final res = await dioCl.get(url);
      if (res.statusCode == 200) {
        final k = 'x-ratelimit-tradeinfopricesminute-reset';
        resetSec = int.tryParse(res.headers.map[k]?.firstOrNull ?? '');

        return List<Map<String, dynamic>>.from(res.data['Data']).toList();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw AppError(code: '429', message: '$resetSec');
      }
    }

    return [];
  }

  //+ hists

  Future<List<SaxoInstrumentOHLCModel>> getInstrumentHistorical({
    required int uic,
    required int horizon,
    DateTime? fromTime,
    int? count, // max 1200, defaul 1200
  }) async {
    final List<String> fieldGroups = ['Data'];

    String url =
        '/chart/v3/charts?AccountKey=${appVM.accountKey}&Uic=$uic&AssetType=Stock&FieldGroups=${fieldGroups.join(',')}&Horizon=$horizon';

    if (fromTime != null) {
      url += "&Mode=From&Time=${fromTime.toUtc().toIso8601String()}";
    }

    if (count != null) {
      url += '&Count=$count';
    }

    final res = await dioCl.get(url);
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(res.data['Data'])
          .map((it) => SaxoInstrumentOHLCModel.fromJson(uic, it))
          .toList();
    }

    return [];
  }

  Future<SaxoInstrumentChartInfoModel?> getInstrumentHistoricalFirstDate({
    required int uic,
  }) async {
    final List<String> fieldGroups = ['ChartInfo'];

    String url =
        '/chart/v3/charts?AccountKey=${appVM.accountKey}&Uic=$uic&AssetType=Stock&FieldGroups=${fieldGroups.join(',')}&Count=1&Horizon=1';

    final res = await dioCl.get(url);
    if (res.statusCode == 200) {
      return SaxoInstrumentChartInfoModel.fromJson(res.data['ChartInfo']);
    }

    return null;
  }

  Future<List<SaxoInstrumentOHLCModel>> getInstrumentHistoricalFull({
    required int uic,
    required int horizon,
    DateTime? fromDt,
  }) async {
    final List<SaxoInstrumentOHLCModel> result = [];

    if (fromDt == null) {
      final res = await getInstrumentHistoricalFirstDate(uic: uic);
      fromDt = res?.firstSampleTime;
      fromDt = fromDt!.subtract(const Duration(minutes: 1));
    }

    int mins0 = 0;

    Future<void> fnNext(DateTime fromDt0) async {
      final res0 = await getInstrumentHistorical(
        uic: uic,
        horizon: horizon,
        fromTime: fromDt0,
      );
      res0.sort((a, b) => a.time.compareTo(b.time));

      if (res0.isNotEmpty) {
        result.addAll(res0);

        DateTime fromDt01 = res0.last.time;
        fromDt01 = fromDt01.add(const Duration(minutes: 1));
        int mins01 = DateTime.now().difference(fromDt01).inMinutes;

        if (histVM.notifLoadingInstrumentPerc != 0) {
          histVM.notifLoadingInstrumentPerc = 100 - mins01 * 100 ~/ mins0;
          histVM.notifLoadingInstrumentHr = horizon == Horizon.m1 ? '1M' : '1D';
          histVM.notify();
        }

        await Future.delayed(500.mlsec);
        await fnNext(fromDt01);
      } else {
        histVM.notifLoadingInstrumentPerc = 0;
        histVM.notifLoadingInstrumentHr = '';
        histVM.notify();
      }
    }

    mins0 = DateTime.now().difference(fromDt).inMinutes;
    if (mins0 > 30) {
      histVM.notifLoadingInstrumentPerc = 1;
      histVM.notifLoadingInstrumentHr = horizon == Horizon.m1 ? '1M' : '1D';
      histVM.notify();
    }

    await fnNext(fromDt);

    return result;
  }
}
