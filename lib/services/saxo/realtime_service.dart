import 'dart:async';
import 'dart:typed_data';

import 'package:lasitrade/logger.dart';
import 'package:web_socket_client/web_socket_client.dart';

import 'package:lasitrade/utils/pref_utils.dart';
import 'package:lasitrade/utils/saxo_utils.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/constants.dart';

class RealtimeService {
  late final WebSocket _sockets;

  Future<void> connect() async {
    final token = await fnPrefGetAccessToken();

    _sockets = WebSocket(
      Uri.parse(
        '$cstApiStreamUrl?authorization=$token&contextId=CtxId_$cstStreamId',
      ),
      binaryType: 'arraybuffer',
      backoff: BinaryExponentialBackoff(
        initial: 1000.mlsec,
        maximumStep: 3,
      ),
    );

    _sockets.messages.listen(_listenMessages);
  }

  void disconnect() {
    _sockets.close(1000, 'CLOSE_NORMAL');
  }

  //+ trade messages

  Future<bool> subscribeToTradeMessages() async {
    final res = await dioCl.post(
      '/trade/v1/messages/subscriptions',
      data: {
        'ContextId': 'CtxId_$cstStreamId',
        'ReferenceId': 'RefId_$cstStreamId',
      },
    );

    return res.statusCode == 200 || res.statusCode == 201;
  }

  Future<bool> unsubscribeFromTradeMessages() async {
    final res = await dioCl.delete(
      '/trade/v1/messages/subscriptions/CtxId_$cstStreamId/RefId_$cstStreamId',
    );

    return res.statusCode == 200 || res.statusCode == 202;
  }

  //+ chart

  Future<bool> subscribeToChart({
    required int uic,
    required int horizon,
  }) async {
    final res = await dioCl.post('/chart/v3/charts/subscriptions', data: {
      'ContextId': 'CtxId_$cstStreamId',
      'ReferenceId': 'RefId_${cstStreamId}__$uic',
      'Arguments': {
        'Uic': uic,
        'AssetType': 'Stock',
        'FieldGroups': ['Data'],
        'Horizon': horizon,
        'Count': 10,
      },
    });

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    }

    return false;
  }

  Future<bool> subscribeToInfoPrices({
    required List<int> uics,
    required String accountKey,
  }) async {
    try {
      final res = await dioCl.post('/trade/v1/infoprices/subscriptions', data: {
        'ContextId': 'CtxId_$cstStreamId',
        'ReferenceId': 'RefId_$cstStreamId',
        'Arguments': {
          'AccountKey': accountKey,
          'Uics': uics.join(','),
          'AssetType': 'Stock',
          'FieldGroups': [
            'PriceInfo',
            'PriceInfoDetails',
            // 'Quote',
            // 'Commissions',
            // 'DisplayAndFormat',
            'HistoricalChanges',
            'InstrumentPriceDetails',
            // 'MarketDepth',
          ],
        },
      });

      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  //-

  void _listenMessages(message) {
    final List<Map<String, dynamic>> data = fnSaxoParseMessageFrame(
      (message as Uint8List).buffer,
    );

    for (var json in data) {
      if (json.containsKey('payload') && json['payload']['Data'] == null) {
        for (Map it in json['payload']) {
          if (it.containsKey('MessageBody')) {
            final data = Map<String, dynamic>.from(it);
            tradeServ.saveAndSeenTradeMessages(data).then((_) async {
              bool isTrailingStep = it['MessageBody'].contains('Trailing step');
              bool isDist01 = it['MessageBody'].contains('Dist. to market 0.1');

              if (!isTrailingStep || isDist01) {
                await tradeVM.init1();

                tradeVM.notify();
                instVM.notify();
              }
            });
          } else {
            // infoprices
          }
        }
      } else {
        // dprint('- - - not payload data - - -');
        // dprint(data);
      }
    }
  }
}
