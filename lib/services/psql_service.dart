import 'package:lasitrade/models/db/db_hist_model.dart';
import 'package:lasitrade/models/db/db_infoprice_model.dart';
import 'package:lasitrade/models/db/db_instrument_model.dart';
import 'package:lasitrade/models/db/db_market_data_model.dart';
import 'package:lasitrade/models/db/db_news_model.dart';
import 'package:lasitrade/models/db/db_trade_message_model.dart';
import 'package:lasitrade/models/db/db_watchlist_model.dart';
import 'package:lasitrade/models/saxo/saxo_instrument_data_model.dart';
import 'package:postgres/postgres.dart';

import 'package:lasitrade/utils/core_utils.dart';

class PsqlService {
  late Connection _conn;

  Future<void> init() async {
    _conn = await Connection.open(
      Endpoint(
        host: fnDotEnv('DB_HOST'),
        database: fnDotEnv('DB_NAME'),
        username: fnDotEnv('DB_USER'),
        password: fnDotEnv('DB_PASSWORD'),
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );

    // _conn.channels.all
  }

  Future<void> close() async {
    await _conn.close();
  }

  //+ nb_instruments

  Future<List<DBInstrumentModel>> selectAllInstruments() async {
    final res = await _conn.execute(
      '''
        SELECT * FROM nb_instruments
      ''',
    );

    return List<DBInstrumentModel>.from(res.map(
      (it) => DBInstrumentModel.fromRowResult(it),
    ));
  }

  Future<DBInstrumentModel> selectInstrumentByUic({required int uic}) async {
    final res = await _conn.execute(
      'SELECT * FROM nb_instruments WHERE uic=$uic',
    );

    return DBInstrumentModel.fromRowResult(res[0]);
  }

  Future<void> removeNotExistsInstrumentsOf(List<int> uics) async {
    if (uics.isEmpty) return;

    await _conn.execute(
      Sql.named('''
        DELETE FROM nb_instruments i
          WHERE NOT EXISTS (
              SELECT 1
              FROM UNNEST(@uics::INT[]) AS u(uic)
              WHERE u.uic = i.uic
          );
      '''),
      parameters: {
        'uics': uics,
      },
    );
  }

  Future<void> insertInstrument(DBInstrumentModel instrument) async {
    await _conn.execute(
      Sql.named(
        '''
            INSERT INTO nb_instruments (
              uic, 
              symbol, 
              name, 
              viewed_at,
              watchlist_ids, 
              created_at
            )
            VALUES (
              @uic, 
              @symbol, 
              @name, 
              @viewed_at, 
              @watchlist_ids, 
              @created_at
            )
            ON CONFLICT DO NOTHING
        ''',
      ),
      parameters: {
        'uic': instrument.uic,
        'symbol': instrument.symbol,
        'name': instrument.name,
        'viewed_at': null,
        'watchlist_ids':
            instrument.watchlistIds.isEmpty ? null : instrument.watchlistIds,
        'created_at': instrument.createdAt.toUtc().toIso8601String(),
      },
    );
  }

  Future<void> updateInstrument({required DBInstrumentModel instrument}) async {
    await _conn.execute(
      Sql.named(
        '''
          UPDATE nb_instruments
            SET viewed_at = @viewedAt,
                watchlist_ids = @watchlist_ids
            WHERE uic=@uic
        ''',
      ),
      parameters: {
        'uic': instrument.uic,
        'viewedAt': instrument.viewedAt?.toUtc().toIso8601String(),
        'watchlist_ids': instrument.watchlistIds,
      },
    );
  }

  //+ nb_infoprices

  Future<void> insertInfoPrices(List<Map<String, dynamic>> data) async {
    if (data.isEmpty) return;

    await _conn.execute(
      Sql.named(
        '''
          INSERT INTO nb_infoprices (
            uic,
            vol,
            relvol,
            lasttraded,
            net_d,
            perc_d,
            lastupdated_at
          )
          SELECT
            uic,
            vol,
            relvol,
            lasttraded,
            net_d,
            perc_d,
            lastupdated_at
          FROM UNNEST(
            @uic::INT[],
            @vol::BIGINT[],
            @relvol::REAL[],
            @lasttraded::REAL[],
            @net_d::REAL[],
            @perc_d::REAL[],
            @lastupdated_at::TIMESTAMPTZ[]
          ) AS t(
            uic,
            vol,
            relvol,
            lasttraded,
            net_d,
            perc_d,
            lastupdated_at
          )
          ON CONFLICT DO NOTHING
        ''',
      ),
      parameters: {
        'uic': data.map((e) => e['uic']).toList(),
        'vol': data.map((e) => (e['vol'] as num).toInt()).toList(),
        'relvol': data.map((e) => e['relvol']).toList(),
        'lasttraded': data.map((e) => e['lasttraded']).toList(),
        'net_d': data.map((e) => e['net_d']).toList(),
        'perc_d': data.map((e) => e['perc_d']).toList(),
        'lastupdated_at': data
            .map((e) =>
                DateTime.parse(e['lastupdated_at']).toUtc().toIso8601String())
            .toList(),
      },
    );
  }

  Future<List<DBInfoPriceModel>> selectLatestInfoPrices() async {
    final res = await _conn.execute(
      '''
        SELECT * FROM (
          SELECT DISTINCT ON (uic) uic,
            infoprice_id, vol, relvol, lasttraded, 
            net_d, perc_d,
            lastupdated_at,
            net_m, perc_m
          FROM nb_infoprices
          WHERE vol >= 10000
          ORDER BY uic, lastupdated_at DESC
        ) t
        ORDER BY net_m DESC;
      ''',
    );

    return List<DBInfoPriceModel>.from(res.map(
      (it) {
        final model = DBInfoPriceModel.fromRowResult(ResultRow(
          values: [
            it[1],
            it[0],
            it[2],
            it[3],
            it[4],
            it[5],
            it[6],
            it[7],
            it[8],
            it[9]
          ],
          schema: it.schema,
        ));

        return model;
      },
    ));
  }

  Future<void> deleteAllNotLatest1DaysInfoPrices() async {
    await _conn.execute(
      '''
      DELETE FROM nb_infoprices
        WHERE lastupdated_at < (
          SELECT MAX(lastupdated_at) - INTERVAL '1 day'
          FROM nb_infoprices
      );
      ''',
    );
  }

  //+ nb_watchlists

  Future<List<DBWatchlistModel>> selectAllWatchlists() async {
    final res = await _conn.execute(
      '''
        SELECT * FROM nb_watchlists
      ''',
    );

    return List<DBWatchlistModel>.from(res.map(
      (it) => DBWatchlistModel.fromRowResult(it),
    ));
  }

  Future<void> createWatchlist({required String name}) async {
    await _conn.execute(
      Sql.named(
        '''
          INSERT INTO nb_watchlists (watchlist_id, name)
            VALUES (DEFAULT, @name)
              ON CONFLICT DO NOTHING
        ''',
      ),
      parameters: {'name': name},
    );
  }

  Future<void> deleteWatchlist({required String watchlistId}) async {
    await _conn.execute(
      Sql.named(
        '''
          DELETE FROM nb_watchlists
            WHERE watchlist_id = @watchlist_id
        ''',
      ),
      parameters: {'watchlist_id': watchlistId},
    );
  }

  //+ nb_news

  Future<List<DBNewsModel>> selectAllNewsByUic({required int uic}) async {
    final res = await _conn.execute('SELECT * FROM nb_news WHERE uic = $uic');

    return List<DBNewsModel>.from(res.map(
      (it) => DBNewsModel.fromRowResult(it),
    ));
  }

  Future<void> insertNews({
    required int uic,
    required String text,
    required String provider,
    required String url,
    required DateTime timeAt,
  }) async {
    await _conn.execute(
      Sql.named(
        '''
          INSERT INTO nb_news (news_id, uic, text, provider, url, time_at)
            VALUES (DEFAULT, @uic, @text, @provider, @url, @time_at)
              ON CONFLICT DO NOTHING
        ''',
      ),
      parameters: {
        'uic': uic,
        'text': text,
        'provider': provider,
        'url': url,
        'time_at': timeAt.toUtc().toIso8601String(),
      },
    );
  }

  //+ nb_trade_messages

  Future<bool> insertTradeMessage({
    required String messageHeader,
    required String messageId,
    required String messageType,
    required String? orderId,
    required String? positionId,
    required String? sourceOrderId,
    required String messageBody,
    required bool seen,
    required DateTime dateTime,
  }) async {
    final sql0 =
        "SELECT * FROM nb_trade_messages WHERE message_id = '$messageId'";
    final res0 = await _conn.execute(sql0);
    if (res0.isNotEmpty) return false;

    await _conn.execute(
      Sql.named(
        '''
          INSERT INTO nb_trade_messages (trade_message_id, message_header, message_id, message_type, order_id, position_id, source_order_id, message_body, seen, date_time)
            VALUES (DEFAULT, @messageHeader, @messageId, @messageType, @orderId, @positionId, @sourceOrderId, @messageBody, @seen, @dateTime)
              ON CONFLICT DO NOTHING
        ''',
      ),
      parameters: {
        'messageHeader': messageHeader,
        'messageId': messageId,
        'messageType': messageType,
        'orderId': orderId,
        'positionId': positionId,
        'sourceOrderId': sourceOrderId,
        'messageBody': messageBody,
        'seen': seen,
        'dateTime': dateTime.toUtc().toIso8601String(),
      },
    );

    return true;
  }

  Future<List<DBTradeMessageModel>> selectTradeMessages({int? orderId}) async {
    String sql = 'SELECT * FROM nb_trade_messages';
    if (orderId != null) {
      sql += ' WHERE order_id = $orderId';
    }

    final res = await _conn.execute(sql);

    return List<DBTradeMessageModel>.from(res.map(
      (it) => DBTradeMessageModel.fromRowResult(it),
    ));
  }

  Future<void> markAsSeenTradeMessage(String messageId) async {
    await _conn.execute(
      Sql.named(
        '''
          UPDATE nb_trade_messages SET seen = true
            WHERE message_id = @messageId
        ''',
      ),
      parameters: {'messageId': messageId},
    );
  }

  //+ nb_hists

  Future<List<DBHistModel>> selectHistByUic({
    required int uic,
    required int horizon,
    bool asc = true,
    int? month,
    int? limit,
  }) async {
    String table = horizon == Horizon.m1 ? 'nb_hists_5m' : 'nb_hists_1d';
    String sql = 'SELECT * FROM $table WHERE uic = $uic';

    if (month != null) {
      sql += " AND time_at >= NOW() - INTERVAL '$month months'";
    }

    sql += asc ? ' ORDER BY time_at ASC' : ' ORDER BY time_at DESC';

    if (limit != null) {
      sql += ' LIMIT $limit';
    }

    final res = await _conn.execute(sql);

    return List<DBHistModel>.from(res.map(
      (it) => DBHistModel.fromRowResult(it),
    ));
  }

  Future<void> insertHists({
    required List<SaxoInstrumentOHLCModel> hists,
    required int horizon,
  }) async {
    if (hists.isEmpty) return;

    final table = horizon == Horizon.m1 ? 'nb_hists_5m' : 'nb_hists_1d';
    final sql = '''
            INSERT INTO $table (
                uic, open, high, low, close, volume, time_at
            )
            SELECT *
            FROM UNNEST(
                @uic::int[],
                @open::numeric[],
                @high::numeric[],
                @low::numeric[],
                @close::numeric[],
                @volume::bigint[],
                @time_at::timestamptz[]
            )
            ON CONFLICT (uic, time_at)
            DO UPDATE SET
              open   = EXCLUDED.open,
              high   = EXCLUDED.high,
              low    = EXCLUDED.low,
              close  = EXCLUDED.close,
              volume = EXCLUDED.volume;
        ''';

    await _conn.execute(
      Sql.named(sql),
      parameters: {
        'uic': hists.map((e) => e.uic).toList(),
        'open': hists.map((e) => e.open).toList(),
        'high': hists.map((e) => e.high).toList(),
        'low': hists.map((e) => e.low).toList(),
        'close': hists.map((e) => e.close).toList(),
        'volume': hists.map((e) => e.volume.toInt()).toList(),
        'time_at': hists.map((e) {
          if (e.time.hour != 0 && e.time.minute != 0) {
            return e.time.toUtc().toIso8601String();
          } else {
            return e.time.toIso8601String();
          }
        }).toList(),
      },
    );
  }

  Future<void> deleteHistByUic({
    required int uic,
  }) async {
    await _conn.execute(
      '''
      DELETE FROM nb_hists_5m WHERE uic=$uic;
      ''',
    );

    await _conn.execute(
      '''
      DELETE FROM nb_hists_1d WHERE uic=$uic;
      ''',
    );
  }

  //+ market data

  Future<void> insertMarketData(DBMarketDataModel marketData) async {
    await _conn.execute(
      Sql.named(
        '''
            INSERT INTO nb_market_data (
              uic,
              price, 
              price_net,
              price_perc,
              market_cap,
              volume,
              volume_per, 
              shs_outstand,
              shs_float,
              shs_float_per, 
              short_interest, 
              short_ratio, 
              short_float,
              time_at 
            )
            VALUES (
              @uic,
              @price, 
              @price_net,
              @price_perc,
              @market_cap,
              @volume,
              @volume_per, 
              @shs_outstand,
              @shs_float,
              @shs_float_per, 
              @short_interest, 
              @short_ratio, 
              @short_float,
              @time_at 
            )
            ON CONFLICT DO NOTHING
        ''',
      ),
      parameters: {
        'uic': marketData.uic,
        //
        'price': marketData.price,
        'price_net': marketData.priceNet,
        'price_perc': marketData.pricePerc,
        'market_cap': marketData.marketCap,
        'volume': marketData.volume,
        'volume_per': marketData.volumePer,
        'shs_outstand': marketData.shsOutstand,
        'shs_float': marketData.shsFloat,
        'shs_float_per': marketData.shsFloatPer,
        'short_interest': marketData.shortInterest,
        'short_ratio': marketData.shortRatio,
        'short_float': marketData.shortFloat,
        //
        'time_at': marketData.timeAt.toUtc().toIso8601String(),
      },
    );
  }

  Future<DBMarketDataModel?> selectLatestMarketDataByUic({
    required int uic,
  }) async {
    final res = await _conn.execute(
      '''
        SELECT * FROM nb_market_data
          WHERE uic = $uic
          ORDER BY time_at DESC
          LIMIT 1;
      ''',
    );

    if (res.isEmpty || res[0].isEmpty) return null;

    return DBMarketDataModel.fromRowResult(res[0]);
  }
}
