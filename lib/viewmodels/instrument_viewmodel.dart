import 'package:collection/collection.dart';

import 'package:lasitrade/models/db/db_instrument_model.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/models/db/db_market_data_model.dart';
import 'package:lasitrade/models/db/db_watchlist_model.dart';
import 'package:lasitrade/utils/alert_utils.dart';
import 'package:lasitrade/models/db/db_news_model.dart';

class InstrumentViewModel extends ChangeNotifierExt {
  List<DBInstrumentModel> instruments = [];

  DBInstrumentModel? instrumentOf(int uic) {
    return instruments.firstWhereOrNull((it) => it.uic == uic);
  }

  DBInstrumentModel? instrumentOfSymbol(String symbol) {
    return instruments.firstWhereOrNull((it) => it.symbol == symbol);
  }

  List<DBInstrumentModel> get instrumentsWatched {
    return instruments.where((it) => it.watched).toList();
  }

  List<DBInstrumentModel> get instrumentsPinned {
    return instruments.where((it) => it.pinned).toList();
  }

  List<DBInstrumentModel> get instrumentsScreenered {
    return instruments.where((it) => it.screenered).toList();
  }

  List<DBInstrumentModel> get instrumentsHistory {
    final list = instruments.where((it) => it.viewedAt != null).toList();
    list.sort((a, b) => b.viewedAt!.compareTo(a.viewedAt!));

    return list;
  }

  late int currUic;
  DBInstrumentModel get currInstrument => instrumentOf(currUic)!;
  String get currSymbol => currInstrument.symbol;

  int currUicN(int inx) => infoPriceVM.infoPricesScreenered[inx].uic;
  DBInstrumentModel currInstrumentN(int inx) => instrumentOf(currUicN(inx))!;
  String currSymbolN(int inx) => currInstrumentN(currUicN(inx)).symbol;

  //+ market data

  DBMarketDataModel? currMarketData;
  bool scrapingMarketData = false;

  //+ news

  List<DBNewsModel> currNews = [];

  //+

  //+ watchlist

  String currWatchlist = 'On Desk';
  int currWatchlistLimit = 50;

  List<DBWatchlistModel> _watchlists = [];
  List<DBWatchlistModel> get watchlists => _watchlists;

  DBWatchlistModel watchlistOf(String name) =>
      _watchlists.firstWhere((it) => it.name == name);

  DBWatchlistModel watchlistPinned() =>
      _watchlists.firstWhere((it) => it.name == 'Pinned');

  //~

  // INIT

  Future<void> init1() async {
    await reInstruments();
    await reWatchlists();

    await instVM.syncExistsInstrumentsSaxoWthDb();

    String symbol = 'NFLX';
    if (instrumentsHistory.isNotEmpty) symbol = instrumentsHistory.first.symbol;
    await setInstrumentBySymbol(symbol, force: true);
  }

  Future<void> reInstruments() async {
    instruments = await psqlServ.selectAllInstruments();
    instruments.sort((a, b) => a.symbol.compareTo(b.symbol));
  }

  Future<void> syncExistsInstrumentsSaxoWthDb() async {
    final saxoInsts1 = await instServ.findInstrument(
      query: '',
      assetType: 'Stock',
      exchangeId: 'NASDAQ',
      limit: 1000,
      doNext: true,
    );

    await Future.delayed(250.mlsec);

    final saxoInsts2 = await instServ.findInstrument(
      query: '',
      assetType: 'Stock',
      exchangeId: 'NSC',
      limit: 1000,
      doNext: true,
    );

    final allSaxoInsts = [...saxoInsts1, ...saxoInsts2];

    await psqlServ.removeNotExistsInstrumentsOf(
      allSaxoInsts.map((e) => e.uic).toList(),
    );

    int newInstCount = 0;
    for (var saxoInst in allSaxoInsts) {
      final inst = instrumentOfSymbol(saxoInst.symbol);
      if (inst == null) {
        await psqlServ.insertInstrument(DBInstrumentModel(
          uic: saxoInst.uic,
          symbol: saxoInst.symbol,
          name: saxoInst.description,
          watchlistIds: [],
          viewedAt: null,
          createdAt: DateTime.now(),
        ));

        newInstCount += 1;
      }
    }

    if (newInstCount != 0) {
      await reInstruments();

      Future.delayed(1000.mlsec, () {
        fnShowToast(text: 'Wow, $newInstCount instrument(s) was added!');
      });
    }
  }

  Future<void> setInstrumentByUic(int uic) async {
    final inst = instrumentOf(uic);
    if (inst != null) {
      await setInstrumentBySymbol(inst.symbol);
    }
  }

  Future<void> setInstrumentBySymbol(
    String symbol, {
    bool force = false,
    Function(bool status)? onLoading,
  }) async {
    final inst = instruments.firstWhereOrNull((it) => it.symbol == symbol);
    if (inst == null) return;

    if (!force && inst == currInstrument) return;

    currUic = inst.uic;

    await reCurrentNews();
    await reCurrentMarketData();

    bool doLoading = false;
    if (await isNeedToScrapeCurrentWithNet()) {
      doLoading = true;
      onLoading?.call(true);

      await scrapeDbSymbolDataWithNet();
    }

    await histVM.syncInstrumentHists1Day(uic: instVM.currUic);
    await histVM.syncInstrumentHists5Min(uic: instVM.currUic, month: 3);

    if (doLoading) {
      onLoading?.call(false);
    }

    currInstrument.viewedAt = DateTime.now();
    await psqlServ.updateInstrument(instrument: currInstrument);
    await reInstruments();

    appVM.notify();
    histVM.notify();

    notify();
  }

  Future<void> updateInstrument(DBInstrumentModel instrument) async {
    await psqlServ.updateInstrument(instrument: instrument);
    await reInstruments();

    currUic = instruments.firstWhere((it) => it.symbol == currSymbol).uic;

    notify();
  }

  //+ news

  Future<void> reCurrentNews() async {
    currNews = await psqlServ.selectAllNewsByUic(uic: currUic);
    currNews.sort((a, b) => b.timeAt.compareTo(a.timeAt));
  }

  //+ market data

  Future<void> reCurrentMarketData() async {
    currMarketData = await psqlServ.selectLatestMarketDataByUic(uic: currUic);
  }

  //+ market data and news

  Future<void> scrapeDbSymbolDataWithNet() async {
    String symbol = currInstrument.symbol;
    if (symbol.endsWith('_NEW')) {
      symbol = symbol.replaceAll('_NEW', '');
    }

    var scrapeRes = await webServ.scrapeSymbol(symbol: symbol);
    if (scrapeRes.$1['market_cap'] == 0 && scrapeRes.$2.isEmpty) {
      scrapeRes = await webServ.scrapeSymbol(
        symbol: symbol.substring(0, currInstrument.symbol.length - 1),
      );
    }

    final List<String> nwUrls = currNews.map((it) => it.url).toList();
    final List<List<dynamic>> newsArr = scrapeRes.$2;
    for (var nwar in newsArr) {
      if (!nwUrls.contains(nwar[3])) {
        await psqlServ.insertNews(
          uic: currUic,
          text: nwar[1],
          provider: nwar[2],
          url: nwar[3],
          timeAt: nwar[0],
        );
      }
    }

    if (newsArr.isNotEmpty) {
      await reCurrentNews();
    }

    await psqlServ.insertMarketData(DBMarketDataModel.fromScrapeJson(
      scrapeRes.$1,
      currInstrument.uic,
    ));

    await reCurrentMarketData();
  }

  Future<bool> isNeedToScrapeCurrentWithNet() async {
    if (currMarketData == null) return true;
    if (currNews.isEmpty) return true;

    return DateTime.now().difference(currMarketData!.timeAt).inMinutes > 5;
  }

  //+ watchlists

  Future<void> reWatchlists() async {
    _watchlists = await psqlServ.selectAllWatchlists();

    for (var watchlist in _watchlists) {
      for (var inst in instruments) {
        if (inst.watchlistIds.contains(watchlist.watchlistId)) {
          watchlist.count += 1;
        }
      }
    }
  }

  Future<void> addWatchlist({required String name}) async {
    await psqlServ.createWatchlist(name: name);
  }

  Future<void> deleteWatchlist({required String watchlistId}) async {
    await psqlServ.deleteWatchlist(watchlistId: watchlistId);
  }

  //+ pinned

  Future<void> pinInstrument(DBInstrumentModel instrument, bool doPin) async {
    final pinnedWatchlistId = instVM.watchlistPinned().watchlistId;

    if (doPin) {
      instrument.watchlistIds.add(pinnedWatchlistId);
    } else {
      instrument.watchlistIds.remove(pinnedWatchlistId);
    }

    await psqlServ.updateInstrument(instrument: instrument);
    await instVM.reInstruments();
    instVM.notify();
  }
}
