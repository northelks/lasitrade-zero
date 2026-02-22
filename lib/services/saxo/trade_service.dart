import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:lasitrade/extensions.dart';

import 'package:lasitrade/getit.dart';
import 'package:lasitrade/models/saxo/saxo_order_model.dart';
import 'package:lasitrade/models/saxo/saxo_position_model.dart';
import 'package:lasitrade/utils/alert_utils.dart';

class TradeService {
  //+ orders

  Future<dynamic> placeBuyOrder({
    required int uic,
    required int amount,
    required double orderPrice,
    required double slPrice,
    required double trailingStopStep,
    bool precheck = false,
    bool externalHours = false,
  }) async {
    String url = '/trade/v2/orders';
    if (precheck) {
      url += '/precheck';
    }

    try {
      final res = await dioCl.post(
        url,
        data: {
          'AccountKey': appVM.accountKey,
          'Uic': uic,
          'BuySell': 'Buy',
          'AssetType': 'Stock',
          'Amount': amount,
          'OrderPrice': orderPrice,
          'OrderType': 'Limit',
          'OrderRelation': 'StandAlone',
          if (externalHours) 'ExecuteAtTradingSession': 'All',
          'ManualOrder': true,
          'OrderDuration': {
            'DurationType': 'GoodTillCancel',
          },
          'ExternalReference': 'EX_UIC_$uic',
          'Orders': [
            {
              'AccountKey': appVM.accountKey,
              'OrderType': 'TrailingStopIfTraded',
              'AssetType': 'Stock',
              'Uic': uic,
              'BuySell': 'Sell',
              'OrderPrice': slPrice,
              'ManualOrder': true,
              'TrailingStopStep': trailingStopStep,
              'TrailingStopDistanceToMarket': trailingStopStep * 10,
            }
          ]
        },
      );

      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (err) {
      if (err is DioException) {
        fnShowToast(title: 'Error', text: err.response.toString());
      }
    }

    return null;
  }

  Future<String?> placeSellOrder({
    required int uic,
    required String assetType,
    required double amount,
    required double orderPrice,
    bool externalHours = false,
  }) async {
    final res = await dioCl.post(
      '/trade/v2/orders',
      data: {
        'AccountKey': appVM.accountKey,
        'Uic': uic,
        'BuySell': 'Sell',
        'AssetType': assetType,
        'Amount': amount,
        'OrderPrice': orderPrice,
        'OrderType': 'Stop',
        'OrderRelation': 'StandAlone',
        if (externalHours) 'ExecuteAtTradingSession': 'All',
        'ManualOrder': true,
        'OrderDuration': {
          'DurationType': 'GoodTillCancel',
        },
      },
    );

    if (res.statusCode == 200) {
      return res.data['OrderId'];
    }

    return null;
  }

  Future<bool> modifyOrder({
    required SaxoOrderModel rlOrder,
    required double orderPrice,
  }) async {
    try {
      final res = await dioCl.patch(
        '/trade/v2/orders',
        data: {
          'AccountKey': appVM.accountKey,
          'OrderId': rlOrder.orderId,
          'AssetType': rlOrder.assetType,
          'OrderType': rlOrder.openOrderType,
          'OrderDuration': {
            'DurationType': 'GoodTillCancel',
          },
          'OrderPrice': orderPrice,
          'TrailingStopStep': 0.01,
          'TrailingStopDistanceToMarket': 0.1,
        },
      );

      return res.statusCode == 200;
    } catch (err) {
      if (err is DioException) {
        fnShowToast(title: 'Error', text: err.response.toString());
      }
    }

    return false;
  }

  Future<bool> cancelOrder({
    required List<String> orderIds,
  }) async {
    if (orderIds.isEmpty) return false;

    final res = await dioCl.delete(
      '/trade/v2/orders/${orderIds.join(',')}?AccountKey=${appVM.accountKey}',
    );

    return res.statusCode == 200;
  }

  Future<List<SaxoOrderModel>> getOrders() async {
    final res = await dioCl.get(
      '/port/v1/orders/me?FieldGroups=DisplayAndFormat',
    );
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(res.data['Data'])
          .map((it) => SaxoOrderModel.fromJson(it))
          .toList();
    }

    return [];
  }

  //+ positions

  Future<List<SaxoPositionModel>> getPositions() async {
    final res = await dioCl.get(
      '/port/v1/positions/me?FieldGroups=DisplayAndFormat,PositionBase,PositionView',
    );
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(res.data['Data'])
          .map((it) => SaxoPositionModel.fromJson(it))
          .toList();
    }

    return [];
  }

  //+ messages

  Future<void> syncTradeMessages() async {
    final res = await dioCl.get('/trade/v1/messages');
    if (res.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(res.data);
      if (data.isNotEmpty) {
        for (var it in data) {
          final msg = tradeVM.messages
              .firstWhereOrNull((e) => e.messageId == it['MessageId']);
          if (msg == null) {
            final isOk = await saveAndSeenTradeMessages(it);
            if (isOk) {
              bool isTrailingStep = it['MessageBody'].contains('Trailing step');
              bool isDist01 = it['MessageBody'].contains('Dist. to market 0.1');

              if (!isTrailingStep || isDist01) {
                await tradeVM.syncOrders();
                await tradeVM.syncPositions();
                await tradeVM.syncBalance();
                tradeVM.notify();

                await fnNotifSound();
                fnShowToast(
                  title: it['MessageHeader'],
                  text: it['MessageBody'],
                  onTap: () {
                    tradeVM.markAllAsSeenMessages().then((_) {
                      appVM.notify();
                    });
                  },
                );

                await Future.delayed(1000.mlsec);
              }
            }
          }
        }
      }
    }
  }

  Future<bool> saveAndSeenTradeMessages(Map<String, dynamic> data) async {
    DateTime dateTime = DateTime.parse(data['DateTime']).toLocal();

    bool isTrailingStep = data['MessageBody'].contains('Trailing step');
    if (isTrailingStep) {
      dateTime = dateTime.add(const Duration(seconds: 1));
    }

    final isOk = await psqlServ.insertTradeMessage(
      messageHeader: data['MessageHeader'],
      messageId: data['MessageId'],
      messageType: data['MessageType'],
      orderId: data['OrderId'],
      positionId: data['PositionId'],
      sourceOrderId: data['SourceOrderId'],
      messageBody: data['MessageBody'],
      seen: false,
      dateTime: dateTime,
    );

    if (isOk) {
      dioCl.put(
        '/trade/v1/messages/seen?MessageIds=${data['MessageId']}',
      );
    }

    return isOk;
  }
}
