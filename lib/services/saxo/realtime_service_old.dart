// import 'dart:async';
// import 'dart:typed_data';

// import 'package:lasitrade/utils/pref_utils.dart';
// import 'package:lasitrade/utils/saxo_utils.dart';
// import 'package:web_socket_client/web_socket_client.dart';

// import 'package:lasitrade/extensions.dart';
// import 'package:lasitrade/getit.dart';
// import 'package:lasitrade/models/saxo/saxo_instrument_data_model.dart';
// import 'package:lasitrade/constants.dart';

// class RealtimeService {
//   late WebSocket _socket;
//   late String _contextId;

//   final Set<int> _uics = {};
//   Set<int> get uics => _uics;

//   Future<void> listen(
//     Function(SaxoInstrumentHistoryModel ohlc) onData,
//   ) async {
//     _contextId = 'Lasitrade_${DateTime.now().millisecondsSinceEpoch}';

//     final String url =
//         '$cstApiStreamUrl?authorization=${await fnPrefGetAccessToken()}&contextId=$_contextId';

//     _socket = WebSocket(
//       Uri.parse(url),
//       binaryType: 'arraybuffer',
//       backoff: BinaryExponentialBackoff(initial: 1000.mlsec, maximumStep: 3),
//     );

//     _socket.messages.listen((message) {
//       final List<Map<String, dynamic>> data = fnSaxoParseMessageFrame(
//         (message as Uint8List).buffer,
//       );

//       print(data);

//       for (var json in data) {
//         if (json['payload'] is Map && json['payload'].containsKey('Data')) {
//           final uic = int.tryParse(
//             (json['referenceId'] as String).split('UIC_').last,
//           );
//           if (uic == null) continue;

//           for (var dt in List<Map<String, dynamic>>.from(
//             json['payload']['Data'],
//           )) {
//             dt['uic'] = uic;

//             if (dt['Volume'] != null) {
//               onData(SaxoInstrumentOHLCModel.fromJson(dt));
//             } else {
//               onData(SaxoInstrumentOOHHLLCCModel.fromJson(dt));
//             }
//           }
//         } else if (json['payload'] is List) {
//           for (Map it in json['payload']) {
//             int uic = 0;
//             if (it.containsKey('Uic')) {
//               uic = it['Uic'];

//               // onData(SaxoInstrumentOHLCModel(
//               //   close: 0.0,
//               //   high: 0.0,
//               //   low: 0.0,
//               //   open: 0.0,
//               //   interest: 0.0,
//               //   time: DateTime.now(),
//               //   uic: uic,
//               //   volume: 0.0,
//               //   ext: true,
//               //   extRelVol:
//               //       (it['InstrumentPriceDetails']?['RelativeVolume'] ?? 0.0) +
//               //           0.0,
//               //   extVol: (it['PriceInfoDetails']?['Volume'] ?? 0.0) + 0.0,
//               // ));
//             }

//             // if (it.containsKey('LastUpdated')) {
//             //   lastUpdated = it['LastUpdated'];
//             // }

//             // if (it.containsKey('Quote')) {
//             //   pQuote.addAll(it['Quote']);
//             // }

//             // if (it.containsKey('PriceInfo')) {
//             //   pQuote.addAll(it['PriceInfo']);
//             // }

//             // if (it.containsKey('Commissions')) {
//             //   print(1);
//             // }

//             // if (it.containsKey('PriceInfoDetails')) {
//             //   pQuote.addAll(it['PriceInfoDetails']);
//             // }

//             // if (pQuote.isNotEmpty && uic != 0) {
//             //   pQuote.addAll({
//             //     'Uic': uic,
//             //     if (lastUpdated != '') 'LastUpdated': lastUpdated,
//             //   });

//             //   final a = SaxoInstrumentFullQuoteModel.fromJson(pQuote);

//             //   // print(pQuote);
//             // }
//           }

//           // print(json['payload']);
//           // for (var dt in List<Map<String, dynamic>>.from(it)) {
//           //   print(dt);
//           // }
//         }
//       }
//     });

//     _socket.connection.listen((it) {
//       print(it);
//     });
//   }

//   //+ chart

//   Future<bool> subscribeToChart({
//     required int uic,
//     required String assetType,
//     required int horizon,
//   }) async {
//     final res = await dioCl.post('/chart/v3/charts/subscriptions', data: {
//       'ContextId': _contextId,
//       'ReferenceId': 'UIC_$uic',
//       'Arguments': {
//         'Uic': uic,
//         'AssetType': assetType,
//         'FieldGroups': ['Data'],
//         'Horizon': horizon,
//         'Count': 10,
//       },
//     });

//     if (res.statusCode == 200 || res.statusCode == 201) {
//       _uics.add(uic);

//       return true;
//     }

//     return false;
//   }

//   Future<bool> unsubscribeFromChart({
//     int? uic,
//   }) async {
//     String url = '/chart/v3/charts/subscriptions/$_contextId';
//     if (uic != null) {
//       url += '/UIC_$uic';
//     }

//     final res = await dioCl.delete(url);
//     if (res.statusCode == 200 || res.statusCode == 202) {
//       _uics.remove(uic);

//       return true;
//     }

//     return false;
//   }

//   //+ InfoPrices = Watchlists

//   Future<bool> subscribeToInfoPrices({
//     required List<int> uics,
//     required String accountKey,
//     String assetType = 'Stock',
//     // required String referenceId,
//   }) async {
//     final now = DateTime.now().millisecondsSinceEpoch;
//     final res = await dioCl.post('/trade/v1/infoprices/subscriptions', data: {
//       'ContextId': _contextId,
//       'ReferenceId': 'ReferenceId_$now',
//       'Arguments': {
//         'AccountKey': accountKey,
//         'Uics': uics.join(','),
//         'AssetType': assetType,
//         'FieldGroups': [
//           'PriceInfo',
//           'PriceInfoDetails',
//           'Quote',
//           'Commissions',
//           'DisplayAndFormat',
//           'HistoricalChanges',
//           'InstrumentPriceDetails',
//           'MarketDepth',
//         ],
//       },
//     });

//     if (res.statusCode == 200 || res.statusCode == 201) {
//       // _referenceIds.putIfAbsent(referenceId, () => {...uics});

//       return true;
//     }

//     return false;
//   }

//   Future<bool> unsubscribeFromInfoPrices({
//     String? referenceId,
//   }) async {
//     String url = '/trade/v1/infoprices/subscriptions/$_contextId';
//     if (referenceId != null) {
//       url += '/$referenceId';
//     }

//     final res = await dioCl.delete(url);
//     if (res.statusCode == 200 || res.statusCode == 202) {
//       // _referenceIds.remove(referenceId);

//       return true;
//     }

//     return false;
//   }

//   //+ trade messages

//   Future<bool> subscribeToTradeMessages() async {
//     final res = await dioCl.post(
//       '/trade/v1/messages/subscriptions',
//       data: {
//         'ContextId': _contextId,
//         'ReferenceId': 'MyTradeMessageEvent',
//       },
//     );

//     if (res.statusCode == 200 || res.statusCode == 201) {
//       return true;
//     }

//     return false;
//   }

//   Future<bool> unsubscribeFromTradeMessages() async {
//     final res = await dioCl.delete(
//       '/trade/v1/messages/subscriptions/$_contextId/MyTradeMessageEvent',
//     );

//     if (res.statusCode == 200 || res.statusCode == 201) {
//       return true;
//     }

//     return false;
//   }

//   void disconnect() {
//     _socket.close(1000, 'CLOSE_NORMAL');
//   }
// }
