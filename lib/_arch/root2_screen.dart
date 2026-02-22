// import 'dart:async';
// import 'dart:math' as math;
// import 'dart:convert';

// import 'package:collection/collection.dart';
// import 'package:dio/dio.dart' as dio;
// import 'package:http/http.dart' as http;

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lasitrade/widgets/chart/_old/candle_data.dart';
// import 'package:lasitrade/constants.dart';
// import 'package:lasitrade/getit.dart';
// import 'package:lasitrade/models/saxo/account_model.dart';
// import 'package:lasitrade/models/saxo/instrument_data_model.dart';
// import 'package:lasitrade/models/saxo/instrument_details_model.dart';
// import 'package:lasitrade/models/saxo/instrument_model.dart';
// import 'package:lasitrade/screens/root/mock_data.dart';
// import 'package:lasitrade/utils/candle_utils.dart';
// import 'package:lasitrade/utils/core_utils.dart';
// import 'package:lasitrade/utils/net_utils.dart';
// import 'package:lasitrade/widgets/buttons/simple_button.dart';
// import 'package:provider/provider.dart';

// import 'package:lasitrade/extensions.dart';
// import 'package:lasitrade/viewmodels/app_viewmodel.dart';
// import 'package:lasitrade/widgets/scaffolds/simple_scaffold.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class Root2Screen extends StatefulWidget {
//   const Root2Screen({super.key});

//   @override
//   State<Root2Screen> createState() => _Root2ScreenState();
// }

// class _Root2ScreenState extends State<Root2Screen> with WidgetsBindingObserver {
//   late ZoomPanBehavior _zoomPan;
//   TrackballBehavior? _trackballBehavior;

//   Map<int, List<SaxoInstrumentOHLCModel>> _chartData = {};
//   Map<int, List<CandleData>> _data0 = {};
//   Map<SaxoInstrumentDetailsModel, (double, double, DateTime)> _dataVol0 = {};

//   DateTime _minDate = DateTime(2900);
//   DateTime _maxDate = DateTime(1900);

//   double _minPrice = 0;
//   double _maxPrice = 0;

//   TooltipBehavior? _tooltipBehavior;

//   // List<InstrumentModel> _symbols = [];
//   List<SaxoInstrumentDetailsModel> _symbolsDet = [];
//   Map<int, double> _symbSpeed = {};
//   List<AccountModel> _ac = [];
//   int _uic = 28946777; // 1249;

//   // List<InstrumentModel> symBl = [];

//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);

//     _zoomPan = ZoomPanBehavior(
//       zoomMode: ZoomMode.x,
//       enableDoubleTapZooming: true,
//       enableMouseWheelZooming: true,
//       enablePinching: true,
//       enablePanning: true,
//       maximumZoomLevel: 0.05,
//     );

//     _trackballBehavior = TrackballBehavior(
//       enable: true,
//       activationMode: ActivationMode.singleTap,
//     );

//     scheduleMicrotask(() async {
//       // await _iii();
//       // await _iii2();

//       await _in();
//       DioClient.iii();
//     });

//     super.initState();
//   }

//   Future<void> _in() async {
//     // _tooltipBehavior = TooltipBehavior(
//     //   enable: true,
//     //   header: 'hear',
//     //   canShowMarker: true,
//     //   builder: (data, point, series, pointIndex, seriesIndex) {
//     //     final PfModel dt = data;

//     //     return Container(
//     //       color: Colors.white,
//     //       height: 50,
//     //       child: Column(
//     //         mainAxisAlignment: MainAxisAlignment.center,
//     //         crossAxisAlignment: CrossAxisAlignment.center,
//     //         children: [
//     //           Text(
//     //             dt.ohlc.time.toIso8601String(),
//     //             style: TextStyle(
//     //               color: Colors.black,
//     //             ),
//     //           ),
//     //           SizedBox(height: 4),
//     //           Text(
//     //             dt.ohlc.close.toString(),
//     //             style: TextStyle(
//     //               color: Colors.black,
//     //             ),
//     //           ),
//     //         ],
//     //       ),
//     //     );
//     //   },
//     // );

//     _ac = await userServ.getAccounts();

//     // final a1 = await userServ.getUser();
//     // final a2 = await userServ.getClient();
//     // final a3 = await userServ.getAccounts();

//     // final b1 = await userServ.getBalance(
//     //   clientKey: ac.first.clientKey,
//     //   accountKey: ac.first.accountKey,
//     // );

//     // final c1 = await userServ.getAccessRights();
//     // final c2 = await userServ.reqFullTradingAndChat();
//     // final c3 = await userServ.getAccessRights();

//     // final ac = await basicServ.updateUser(
//     //   language: 'no',
//     //   culture: 'en-GB',
//     //   timeZoneId: '12',
//     // );

//     // final acw = await instServ.findInstrument(
//     //   accountKey: _ac.first.accountKey,
//     //   query: 'SOUN',
//     //   // exchangeId: 'NASDAQ',
//     //   // assetType: 'CfdOnStock',
//     // );

//     // 28946777 = SOUN

//     final ff = await userServ.reqFullTradingAndChat();

//     final acw = await instServ.findInstrument(
//       accountKey: _ac.first.accountKey,
//       query: 'SOUN',
//       exchangeId: 'NASDAQ',
//       // assetType: 'CfdOnStock',
//     );

//     final aaa2 = await instServ.getInstrumentDetails(
//       uic: 28946777,
//       assetType: 'Stock',
//     );

//     final asdf = await instServ.getInstrumentPrice(
//       accountKey: _ac.first.accountKey,
//       assetType: 'Stock',
//       uic: 28946777,
//     );

//     print(1);

//     //   "28014267",
//     //   "44235134",
//     //   "41442570",
//     //   "1437120",
//     //   "1708603",
//     //   "30564318",

//     // final aaaaa = await instServ.getInstrumentHistorical(
//     //   accountKey: _ac.first.accountKey,
//     //   assetType: 'Stock',
//     //   uic: 30564318,
//     //   horizon: Horizon.m1,
//     //   isDisplayAndFormat: true,
//     //   // count: 10,
//     // );

//     // print(1);

//     // print(jsonEncode(aaaaa!.data));

//     // final aa = await instServ.findInstrument(
//     //   accountKey: _ac.first.accountKey,
//     //   // query: '',
//     //   exchangeId: 'NSC',
//     //   assetType: 'Stock',
//     //   limit: 1000,
//     //   includeNonTradable: false,
//     //   doNext: true,
//     // );
//     // print(aa);

//     ///////
//     ///////
//     ///

//     // final sd = stockssss.replaceAll('\n', ',');
//     // var sdar = sd.split(',');
//     // sdar.removeLast();

//     // final maps = {};
//     // for (var stk in sdar) {
//     //   await Future.delayed(Duration(milliseconds: 1000));

//     //   final symb = await instServ.findInstrument(
//     //     accountKey: _ac.first.accountKey,
//     //     query: stk,
//     //     // assetType: 'Stock',
//     //   );

//     //   if (symb.isNotEmpty) {
//     //     for (var it in symb) {
//     //       if (it.symbol == '$stk:xnas') {
//     //         maps.putIfAbsent(stk, () => it.uic);

//     //         print('$stk ${it.uic}');
//     //       }
//     //     }
//     //   }
//     // }

//     ///////
//     ///////
//     ///

//     // print(11111111111111);

//     // for (var it in maps.entries) {
//     //   print('${it.key} ${it.value}');
//     // }

//     _chartData.clear();
//     _data0.clear();

//     // await _parseSymbol(_uic);

//     Future<void> plisten(SaxoInstrumentHistoryModel ohlc) async {
//       final SaxoInstrumentOHLCModel ohlcc = ohlc as SaxoInstrumentOHLCModel;

//       final inst = SaxoInstrumentOHLCModel(
//         uic: ohlcc.uic,
//         close: ohlcc.close,
//         high: ohlcc.high,
//         low: ohlcc.low,
//         open: ohlcc.open,
//         interest: ohlcc.interest,
//         volume: ohlcc.volume,
//         time: ohlcc.time,
//       );

//       final cdl = CandleData(
//         timestamp: inst.time.millisecondsSinceEpoch,
//         open: inst.open,
//         high: inst.high,
//         low: inst.low,
//         close: inst.close,
//         volume: inst.volume.toDouble(),
//         // volume: vol,d
//       );

//       // double volum = 0;
//       // final now = DateTime.now();
//       final smv = _symbolsDet.firstWhereOrNull((it) => it.uic == inst.uic);
//       if (smv != null) {
//         if (!_dataVol0.containsKey(smv)) {
//           _dataVol0.putIfAbsent(
//               smv,
//               () => (
//                     cdl.volume ?? 0.0,
//                     cdl.close ?? 0.0,
//                     cdl.date,
//                   ));

//           setState(() {});
//         } else {
//           double volum = 0;
//           final dt = DateTime.fromMillisecondsSinceEpoch(cdl.timestamp);
//           if (_dataVol0[smv]!.$3.difference(dt).inMinutes.abs() <= 5) {
//             volum += cdl.volume ?? 0.0;

//             _dataVol0[smv] = (volum, cdl.close ?? 0.0, _dataVol0[smv]!.$3);

//             setState(() {});
//           } else {
//             _dataVol0[smv] = (cdl.volume ?? 0.0, cdl.close ?? 0.0, cdl.date);

//             setState(() {});
//           }
//         }
//       }
//     }

//     await rtServ.listen((it) => plisten(it));

//     final ss = ssst2.split('\n').map((it) => it.split(' ').last).toList();
//     // print(ss);

//     // final ssr = [
//     //   "28014267",
//     //   "44235134",
//     //   "41442570",
//     //   "1437120",
//     //   "1708603",
//     //   "30564318",
//     // ];

//     final as = await userServ.reqFullTradingAndChat();

//     ss.shuffle();

//     // await rtServ.subscribeToChart(
//     //   uic: 28946777,
//     //   assetType: 'Stock',
//     //   horizon: 5,
//     // );

//     // 28946777

//     // final aee = ss.take(100);
//     // final c = await rtServ.subscribeToInfoPrices(
//     //   uics: aee.map((it) => int.parse(it)).toList(),
//     //   // uics: [28946777],
//     //   assetType: 'Stock',
//     //   accountKey: _ac.first.accountKey,
//     //   referenceId: 'InfoPricesData1',
//     // );

//     print(1);

//     // final ss123 = ss.take(20).toList();
//     // ss123.add('28946777');
//     // for (var it in ['28946777']) {
//     //   await Future.delayed(const Duration(milliseconds: 500));
//     //   // await rtServ.subscribeToChart(
//     //   //   uic: int.parse(it),
//     //   //   assetType: 'Stock',
//     //   //   horizon: 1,
//     //   // );

//     //   await rtServ.subscribeToInfoPrices(
//     //       uics: [int.parse(it)],
//     //       assetType: 'Stock',
//     //       accountKey: _ac.first.accountKey,
//     //       referenceId: 'Stock_${int.parse(it)}'
//     //       // horizon: 1,
//     //       );

//     //   await Future.delayed(const Duration(milliseconds: 500));
//     //   final SaxoInstrumentDetailsModel? aaa = await instServ.getInstrumentDetails(
//     //     uic: int.parse(it),
//     //     assetType: 'Stock',
//     //   );
//     //   if (aaa != null) {
//     //     _symbolsDet.add(aaa);

//     //     print('+ ${aaa.symbol}');
//     //   }
//     // }

//     // final List<SaxoInstrumentHistoricalModel> as2 = [];

//     // for (var ieee in ssr) {
//     //   final aaaaa = await instServ.getInstrumentHistorical(
//     //     accountKey: _ac.first.accountKey,
//     //     assetType: 'Stock',
//     //     uic: int.parse(ieee),
//     //     horizon: Horizon.m1,
//     //     isDisplayAndFormat: true,
//     //   );

//     //   if (aaaaa == null) continue;

//     //   as2.add(aaaaa);

//     //   // final List<SaxoInstrumentHistoryModel> data = aaaaa.data;
//     //   // for (var ee in data) {
//     //   //   await plisten(ee);

//     //   //   await Future.delayed(Duration(milliseconds: 500));
//     //   // }
//     // }

//     // void cun2() async {
//     //   for (var it in as2) {
//     //     if (it.data.isNotEmpty) {
//     //       final at = it.data.removeAt(0);
//     //       await plisten(at);

//     //       await Future.delayed(Duration(milliseconds: 100));
//     //     }
//     //   }

//     //   // cun2();
//     // }

//     // cun2();

//     // for (var sm in _symbols.take(100)) {
//     //   await Future.delayed(const Duration(milliseconds: 50));
//     //   await _parseSymbol(sm.uic);
//     // }
//   }

//   Future<void> _parseSymbol(int uic) async {
//     setState(() {
//       _chartData.clear();
//       _data0.clear();
//       _uic = uic;
//       _minDate = DateTime(2900);
//       _maxDate = DateTime(1900);
//     });

//     final aaaaa = await instServ.getInstrumentHistorical(
//       accountKey: _ac.first.accountKey,
//       assetType: 'Stock',
//       uic: uic,
//       horizon: Horizon.m5,
//       isDisplayAndFormat: true,
//     );

//     // final asdf = await instServ.getInstrumentPrice(
//     //   accountKey: ac.first.accountKey,
//     //   assetType: 'Stock',
//     //   uic: 18349622,
//     // );

//     for (var it in (List<SaxoInstrumentOHLCModel>.from(aaaaa!.data))) {
//       if (_maxDate.compareTo(it.time) == -1) {
//         _maxDate = it.time;
//       }

//       if (_minDate.compareTo(it.time) == 1) {
//         _minDate = it.time;
//       }

//       double close = it.close;

//       if (_minPrice == 0 || _minPrice > close) {
//         _minPrice = close;
//       }

//       if (_maxPrice == 0 || _maxPrice < close) {
//         _maxPrice = close;
//       }

//       final val = _chartData.putIfAbsent(it.uic, () => []);
//       final inst = SaxoInstrumentOHLCModel(
//         uic: it.uic,
//         close: it.close,
//         high: it.high,
//         low: it.low,
//         open: it.open,
//         interest: it.interest,
//         volume: it.volume,
//         time: it.time,
//       );
//       val.add(inst);

//       final vall = _data0.putIfAbsent(it.uic, () => []);
//       vall.add(CandleData(
//         timestamp: inst.time.millisecondsSinceEpoch,
//         open: inst.open,
//         high: inst.high,
//         low: inst.low,
//         close: inst.close,
//         volume: inst.volume.toDouble(),
//       ));
//     }

//     setState(() {});

//     // Future.delayed(const Duration(milliseconds: 2500), () {
//     //   _zoomPan.zoomByFactor(0.1);
//     //   setState(() {});
//     // });

//     // final a = await rtServ.listen((SaxoInstrumentOHLCModel ohlc) {
//     //   print(ohlc);
//     // });

//     // final b = await rtServ.subscribeToChart(
//     //   uic: 16,
//     //   assetType: 'FxSpot',
//     //   horizon: 1,
//     // );

//     // final c = await rtServ.subscribeToChart(
//     //   uic: 12,
//     //   assetType: 'FxSpot',
//     //   horizon: 1,
//     // );

//     // final c = await rtServ.subscribeToInfoPrices(
//     //   uics: [4, 12, 14, 17],
//     //   assetType: 'FxSpot',
//     //   accountKey: ac.first.accountKey,
//     //   referenceId: 'InfoPricesData1',
//     // );

//     // final as = await rtServ.reqFullTradingAndChat();

//     // final qw = await rtServ.subscribeToEvents();
//     // final qw2 = await rtServ.subscribeToMessages();

//     // final aw0 = await tradeServ.getOrderPrecheck(
//     //   accountKey: ac.first.accountKey,
//     //   uic: 16,
//     //   assetType: 'FxSpot',
//     //   amount: 100000,
//     //   orderPrice: 7.46800,
//     //   slPrice: 7.46500,
//     // );

//     // final aw = await tradeServ.placeOrder(
//     //   accountKey: ac.first.accountKey,
//     //   uic: 16,
//     //   assetType: 'FxSpot',
//     //   amount: 100000,
//     //   orderPrice: 7.46800,
//     //   slPrice: 7.46500,
//     // );

//     // await Future.delayed(const Duration(seconds: 5));

//     // final a1 = await tradeServ.getOpenPositions(
//     //   clientKey: ac.first.clientKey,
//     // );

//     // final a3 = await tradeServ.getClosedPositions(
//     //   clientKey: ac.first.clientKey,
//     // );

//     // final b1 = await tradeServ.getOrders(
//     //   clientKey: ac.first.clientKey,
//     // );

//     // final n1 = await tradeServ.getTradeMessages();

//     // final n11 = await tradeServ.getHistoricalEnsEvents(
//     //   fromDateTime: DateTime.now().subtract(const Duration(days: 7)),
//     // );

//     // print(2);

//     // final aa1 = await tradeServ.getHistoricalOrders(
//     //   clientKey: ac.first.clientKey,
//     //   accountKey: ac.first.accountKey,
//     //   fromDateTime: DateTime.now().subtract(const Duration(days: 7)),
//     // );
//   }

//   @override
//   void didChangeDependencies() {
//     context.watch<AppViewModel>();

//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);

//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {}
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sorted = _dataVol0.entries.toList()
//       ..sort((a, b) => b.value.$1.compareTo(a.value.$1));

//     return AppSimpleScaffold(
//       title: 'lasitrade',
//       hideBack: true,
//       children: [
//         10.h,
//         Text('Hello World!'),
//         10.h,
//         // SizedBox(
//         //   width: context.width * 0.5,
//         //   child: AppSimpleButton(
//         //     text: 'unsubscribe',
//         //     onTap: () async {
//         //       // await rtServ.unsubscribeFromChart();
//         //       // rtServ.disconnect();

//         //       // final ac = await userServ.getAccounts();
//         //       // final ad = await tradeServ.placeOrder(
//         //       //   accountKey: ac.first.accountKey,
//         //       //   uic: 16,
//         //       //   assetType: 'FxSpot',
//         //       //   amount: 10000,
//         //       //   orderPrice: 7.45877,
//         //       //   slPrice: 7.45577,
//         //       //   precheck: true,
//         //       // );

//         //       // final ad22 = await tradeServ.modifyOrder(
//         //       //   accountKey: ac.first.accountKey,
//         //       //   orderId: '5034988465',
//         //       //   orderType: 'TrailingStop',
//         //       //   assetType: 'FxSpot',
//         //       //   // amount: 10000,
//         //       //   orderPrice: 7.45544,
//         //       // );

//         //       // final ad22 = await tradeServ.cancelOrder(
//         //       //   accountKey: ac.first.accountKey,
//         //       //   orderIds: ['5034996040', '5034996263'],
//         //       // );

//         //       // 5023600595

//         //       // final a = await tradeServ.placeSellOrder(
//         //       //   accountKey: ac.first.accountKey,
//         //       //   uic: 16,
//         //       //   assetType: 'FxSpot',
//         //       //   amount: 5000,
//         //       //   orderPrice: 7.46020,
//         //       // );
//         //     },
//         //   ),
//         // ),
//         10.h,
//         Container(
//           width: context.width,
//           child: Row(
//             children: [
//               Container(
//                 width: context.width * 0.2,
//                 height: context.height * 0.7,
//                 child: ListView(
//                   children: [
//                     if (sorted.isEmpty)
//                       Text("  Empty.")
//                     else
//                       for (var t2 in sorted)
//                         Center(
//                           child: GestureDetector(
//                             onTap: () async {
//                               await _parseSymbol(t2.key.uic);
//                             },
//                             child: Container(
//                               height: 65,
//                               width: context.width * 0.18,
//                               margin: const EdgeInsets.only(bottom: 10),
//                               decoration: BoxDecoration(
//                                 color: t2.key.uic == _uic
//                                     ? Colors.red.withOpacity(0.3)
//                                     : Colors.transparent,
//                                 border: Border.all(
//                                   width: 0.5,
//                                   color: Colors.white.withOpacity(0.5),
//                                 ),
//                               ),
//                               child: Center(
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       t2.key.symbol.replaceAll(':xnas', ''),
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.white,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                     Text(
//                                       DateFormat('MM.dd HH:mm')
//                                           .format(t2.value.$3),
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.white,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 20),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             '${t2.value.$2}',
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.white,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                           Text(
//                                             '${t2.value.$1.toStringAsFixed(0)}',
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.white,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: context.width * 0.8,
//                 height: context.height * 0.7,
//                 child: _data0.containsKey(_uic) && _data0[_uic]!.length >= 3
//                     ? InteractiveChart(
//                         candles: _data0.containsKey(_uic) ? _data0[_uic]! : [],
//                         style: ChartStyle(
//                           // priceGainColor: Colors.teal[200]!,
//                           // priceLossColor: Colors.blueGrey,
//                           // volumeColor: Colors.teal.withOpacity(0.8),
//                           trendLineStyles: [
//                             Paint()
//                               ..strokeWidth = 1.0
//                               ..strokeCap = StrokeCap.round
//                               ..color = Colors.white,
//                             // Paint()
//                             //   ..strokeWidth = 1.0
//                             //   ..strokeCap = StrokeCap.round
//                             //   ..color = Colors.blue,
//                             // Paint()
//                             //   ..strokeWidth = 1.0
//                             //   ..strokeCap = StrokeCap.round
//                             //   ..color = Colors.orange,
//                           ],
//                           priceGridLineColor: Colors.blue[200]!,
//                           priceLabelStyle: TextStyle(color: Colors.blue[200]),
//                           timeLabelStyle: TextStyle(color: Colors.blue[200]),
//                           selectionHighlightColor: Colors.red.withOpacity(0.2),
//                           overlayBackgroundColor:
//                               Colors.red[900]!.withOpacity(0.6),
//                           overlayTextStyle: TextStyle(color: Colors.red[100]),
//                           timeLabelHeight: 32,
//                           volumeHeightFactor:
//                               0.2, // volume area is 20% of total height
//                         ),
//                         // timeLabel: (timestamp, visibleDataCount) => "📅",
//                         // priceLabel: (price) => "${price.round()} 💎",
//                         // overlayInfo: (candle) => {
//                         //   "💎": "🤚    ",
//                         //   "Hi": "${candle.high?.toStringAsFixed(2)}",
//                         //   "Lo": "${candle.low?.toStringAsFixed(2)}",
//                         // },
//                         onTap: (candle) => print("user tapped on $candle"),
//                         // onCandleResize: (width) => print("each candle is $width wide"),
//                       )
//                     : Container(),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//   // double priceToY(
//   //   double price,
//   //   double minPrice,
//   //   double maxPrice,
//   //   double chartHeight,
//   // ) {
//   //   // Prevent division by zero if max and min are the same
//   //   if (maxPrice == minPrice) return chartHeight / 2;
//   //   // The calculation to convert price to a Y-pixel value
//   //   // We subtract from chartHeight because canvas Y=0 is at the top
//   //   return chartHeight -
//   //       (((price - minPrice) / (maxPrice - minPrice)) * chartHeight);
//   // }
// }

// final stockssss = '''
// FGI
// LVO
// MODD
// IBIO
// TC
// SONM
// ASRT
// SCYX
// VRME
// GOVX
// ORGN
// BANL
// MOVE
// STEC
// SKBL
// KTTA
// CHEK
// CAN
// SHOT
// MSAI
// ACET
// ICU
// REE
// NXPL
// SMSI
// SLRX
// NVVE
// IVP
// BIYA
// EDHL
// AQB
// ITRM
// CCG
// PAVS
// ORKT
// CPOP
// TNYA
// NAUT
// BKYI
// EHGO
// BCTX
// POAI
// IRWD
// XRTX
// TROO
// LFWD
// WOK
// FTEL
// IVVD
// HCAI
// ATOS
// SUGP
// SFHG
// STTK
// PHH
// NCEW
// CUE
// YXT
// LSH
// KXIN
// PRTS
// TOUR
// SJ
// CNTX
// NMTC
// FEMY
// BDRX
// ENGNW
// EPOW
// XBP
// CDTG
// IFRX
// TPIC
// AERT
// ADD
// SLXN
// SGD
// SOHO
// YTRA
// LEXX
// STRO
// PRLD
// PRSO
// WINT
// HOOK
// ESLA
// NAOV
// MSS
// PMN
// WETH
// PT
// ZTEK
// CMBM
// NDLS
// CTSO
// MTC
// CIIT
// CNFR
// SMTK
// VRAX
// VIVK
// SDOT
// MAPS
// PETZ
// CLPS
// JBDI
// EDTK
// TOMZ
// WGRX
// GIFT
// SFWL
// NAMI
// OSRH
// ZBAO
// VCIG
// LSB
// KITT
// CGTL
// CBAT
// MSPR
// TLIH
// PRPL
// CXAI
// IFBD
// PMCB
// ZCMD
// ICCM
// NWGL
// BLNK
// CMND
// LPSN
// YGMZ
// RMTI
// FGL
// SMXT
// CISO
// MOBX
// SGLY
// UK
// INLF
// FEBO
// IMTE
// MASK
// MNDR
// OCGN
// JCSE
// JXG
// TIRX
// CHRS
// GLBS
// ANTX
// BFRI
// LXRX
// SKYX
// JZXN
// CCTG
// TVGN
// ONCY
// LUCD
// TNON
// GAME
// GRWG
// PSNY
// AACG
// CGC
// CMMB
// DYAI
// HYPR
// IMUX
// SELX
// SEED
// TGL
// ABLV
// GRYP
// ISPC
// ALLR
// XWEL
// AKTX
// INEO
// NXL
// WFF
// KLTO
// SGRP
// STKH
// MESA
// EM
// ALTO
// GERN
// NWTN
// SIDU
// AREC
// MNTS
// SCKT
// PDSB
// POWW
// TXMD
// IXHL
// SOWG
// IRD
// ADTX
// WTO
// MWYN
// REKR
// TOP
// PALI
// CLWT
// HKPD
// HUDI
// ENLV
// MVIS
// BOLD
// INTJ
// WYHG
// SOPA
// ELBM
// MYPS
// ONFO
// TYGO
// MRM
// PYXS
// LXEH
// RNXT
// SNAL
// KNDI
// DXST
// ENVB
// IGMS
// GXAI
// CETX
// AEMD
// XCH
// AKAN
// AMIX
// DLPN
// RELI
// ATPC
// BITF
// SXTP
// HOTH
// AMOD
// BEAT
// EVGN
// RDZN
// SNGX
// VSA
// OMH
// GFAI
// RDGT
// VSME
// FPAY
// XHG
// MDIA
// DSY
// MYSZ
// FATE
// RXT
// USEG
// IINN
// VSEE
// XPON
// ATER
// EDUC
// RDI
// OPK
// HOWL
// BON
// SUUN
// CERS
// RMCO
// TBH
// WRAP
// ARAY
// GPRO
// ANTE
// AREB
// HAO
// DXLG
// GIPR
// HKIT
// INHD
// LBGJ
// ANL
// TDTH
// WAFU
// BGFV
// RNTX
// LAB
// MNDO
// NNDM
// NVX
// AEI
// ACRV
// LVTX
// PEPG
// GIGM
// HWH
// HXHX
// GEVO
// VFF
// THAR
// VYNE
// ZNTL
// ALLO
// OLPX
// MNOV
// ABOS
// PMEC
// GV
// LGO
// OGI
// GTIM
// CAPT
// INO
// PRFX
// BFRG
// DWSN
// PMVP
// ZENV
// ARBE
// SNDL
// DCGO
// PLRZ
// YIBO
// CGEN
// INBS
// BTBD
// EDAP
// INCR
// IRIX
// HMR
// BLIN
// CAPS
// PNBK
// COCH
// GMHS
// SBFM
// MIST
// MIST
// CTXR
// XELB
// PGEN
// MRKR
// CRDL
// SWAG
// BRLT
// ECX
// BRNS
// BRTX
// PLRX
// ADV
// CNET
// JUNS
// CTNT
// OLB
// USEA
// BTOC
// CBUS
// HIT
// RPTX
// FTHM
// VANI
// NXXT
// CASI
// BJDX
// CLYM
// GMGI
// SYBX
// WLDS
// ESPR
// ADGM
// HOVR
// PFSA
// TRAW
// ZURA
// NCRA
// GANX
// EJH
// LGVN
// MGIH
// IMRN
// HIHO
// COCP
// JFU
// LOOP
// PACB
// RDHL
// YHC
// XTLB
// SANW
// GREE
// ACRS
// BTAI
// KIRK
// SUNE
// ASTI
// ERAS
// MGNX
// SPWR
// VEEA
// OMEX
// MGRX
// APM
// CABA
// FRGT
// VRAR
// SAFX
// SEAT
// CAMP
// JZ
// REFR
// MIRA
// GTEC
// XTKG
// PLUG
// FARM
// ATLN
// MEGL
// OFAL
// SKIN
// TRSG
// CHR
// IKT
// MOGO
// HAIN
// QSI
// ABVE
// GNSS
// KBSX
// KMRK
// MREO
// PFAI
// PRZO
// INVZ
// SLS
// IMMP
// PSHG
// RMCF
// USIO
// AISPW
// BAER
// CSTE
// QNCX
// PTNM
// BMEA
// LEDS
// FAMI
// STFS
// WHWK
// YJ
// CRIS
// FLUX
// HOUR
// PODC
// AGAE
// UONE
// WNW
// AGH
// FOSL
// ALEC
// APWC
// BHAT
// STAK
// BNRG
// SNTG
// INTZ
// APRE
// EPIX
// LRE
// PLBY
// WKHS
// CTOR
// OCTO
// HRTX
// SNTI
// IMAB
// TLSA
// KLTR
// AHG
// GDTC
// GELS
// NIXX
// OXBR
// WETO
// ERNA
// IQ
// AIXI
// TCRX
// CREG
// CDT
// MBIO
// SSKN
// NWTG
// RR
// TELA
// FORA
// TRUE
// BYSI
// CVGI
// GLMD
// MYNZ
// KOPN
// MJID
// KLXE
// FBIO
// IHRT
// RYET
// IPM
// ADAG
// ADN
// ELUT
// NRSN
// DGLY
// OTLK
// GOSS
// MCHX
// SYPR
// GUTS
// KIDZ
// NLSP
// SND
// ONDS
// BLDP
// IPA
// SCNX
// CNTB
// YQ
// BDMD
// MNY
// JWEL
// GTBP
// NXTT
// SHIM
// CRON
// OPTX
// OABI
// NCI
// NTCL
// BOXL
// QRHC
// SCNI
// XTIA
// NIPG
// NERV
// GRI
// TANH
// DTSS
// EGHT
// LMFA
// LUCY
// TELO
// STRR
// FNGR
// IVDA
// HLVX
// XFOR
// SOND
// CLNE
// WALD
// CURR
// GEG
// IVF
// LVRO
// NNBR
// NOTV
// VERI
// GRNQ
// HGBL
// SAGT
// DUO
// EFOI
// POLA
// QIPT
// AAME
// BLNE
// ORMP
// IPHA
// LOT
// TAIT
// SEER
// ENTX
// VUZI
// NKTX
// QTTB
// CCCC
// BCG
// JAGX
// VIVS
// HIVE
// EXFY
// BMGL
// NXGL
// RMSG
// TURB
// AWRE
// FMST
// PRQR
// SDA
// BCDA
// CTRM
// DTI
// ELAB
// FLNT
// VRA
// CRBU
// HITI
// MXCT
// ENSC
// MNTK
// PPBT
// SPRO
// CMTL
// OPEN
// LIQT
// NMRA
// VEEE
// SMX
// OXSQ
// INAB
// RETO
// CRNT
// QMMM
// OKUR
// DLTH
// AGMH
// CLGN
// UCAR
// EDSA
// CTMX
// VOR
// CDLX
// NVFY
// NSPR
// YYGH
// SAVA
// BZFD
// MDCX
// MURA
// ACIU
// AXTI
// RSLS
// FAT
// IPDN
// EDBL
// CCLD
// IOBT
// ZKIN
// APYX
// SVRE
// VS
// BLIV
// HUMA
// CARV
// GROW
// OPAL
// MAMK
// HEPS
// UTSI
// RMBL
// AUTL
// ANNX
// DARE
// MGX
// MDXH
// PHIO
// RAY
// CNEY
// CNTY
// ZYXI
// IZM
// HUIZ
// VERO
// TALK
// MCTR
// DATS
// LWLG
// FTFT
// CPSH
// BEEM
// LPRO
// MGRT
// MAMO
// GMM
// RIME
// GITS
// SABS
// INM
// UPLD
// FATBB
// JDZG
// AIMD
// AYTU
// CELZ
// FFAI
// ZEO
// TSHA
// BOF
// SHMD
// UFG
// GSUN
// IBRX
// MRVI
// ADVM
// CJET
// SVRA
// ICON
// ACHV
// BSLK
// FTEK
// QLGN
// REVB
// MDAI
// IMMX
// HBNB
// LSTA
// TUSK
// OKYO
// WXM
// ISPO
// CNDT
// LGCB
// UOKA
// ALZN
// HURA
// BZUN
// DIBS
// IMCC
// RSSS
// ICG
// LCID
// BWEN
// CIGL
// REBN
// SINT
// LAWR
// MSW
// RCT
// MMLP
// CREX
// CYCN
// IDAI
// IMDX
// ASRV
// CLLS
// SURG
// XBIT
// ICMB
// TLS
// THCH
// LHSW
// UCL
// CRWS
// EVAX
// KLRS
// ABAT
// GLE
// BRLS
// CWD
// ESGL
// INMB
// RCON
// KPRX
// ELWS
// LASE
// MBOT
// AIFF
// UROY
// RAVE
// DEFT
// APVO
// CDZI
// IOVA
// PLUT
// NRXP
// BDTX
// SVC
// FCUV
// RZLV
// ZSPC
// BBLG
// CLOV
// NB
// RBNE
// ENGS
// HFFG
// LGHL
// VGAS
// ABSI
// BAOS
// TEAD
// BTCT
// DRTS
// SGMA
// EDIT
// ARTV
// BTBT
// EU
// KTCC
// TORO
// GRCE
// VTYX
// ''';

// final ssst2 = '''
// FGI 26806400
// LVO 25287254
// MODD 27453741
// IBIO 47931269
// TC 19903260
// SONM 14025556
// ASRT 10477273
// SCYX 1450732
// VRME 21296758
// GOVX 20880755
// ORGN 23662367
// BANL 35006862
// MOVE 22106805
// STEC 43444381
// SKBL 47492368
// KTTA 25380172
// CHEK 9605745
// CAN 15577541
// SHOT 37696022
// MSAI 40494956
// ACET 19216796
// ICU 33307877
// REE 24075695
// NXPL 27001692
// SMSI 6431
// SLRX 14396994
// NVVE 22101167
// IVP 37392892
// BIYA 50007641
// EDHL 50093684
// AQB 5985748
// ITRM 12045775
// CCG 42896399
// PAVS 34404859
// ORKT 45137714
// CPOP 23768604
// TNYA 24677827
// NAUT 23405083
// BKYI 43128
// EHGO 43201328
// BCTX 22369919
// POAI 14082421
// IRWD 42905
// XRTX 25762577
// TROO 25931568
// LFWD 40152339
// WOK 47749260
// FTEL 42179458
// IVVD 31276235
// HCAI 47403900
// ATOS 301416
// SUGP 40055028
// SFHG 45344798
// STTK 19712161
// PHH 49732976
// NCEW 46408635
// CUE 8747161
// KXIN 18362344
// PRTS 25576
// TOUR 859553
// SJ 23194861
// CNTX 25577687
// NMTC 21203647
// FEMY 28187539
// BDRX 34695910
// EPOW 30736256
// XBP 42010838
// CDTG 41709647
// IFRX 8291917
// TPIC 4641459
// AERT 42355672
// ADD 32182085
// SLXN 44227674
// SGD 37906839
// SOHO 1664722
// YTRA 6399347
// LEXX 20867160
// STRO 10856703
// PRLD 19392472
// PRSO 26502452
// WINT 3969969
// HOOK 14346413
// ESLA 41138866
// NAOV 19324950
// MSS 37997716
// PMN 36852448
// WETH 21203810
// PT 15015454
// CMBM 16727935
// NDLS 417126
// CTSO 46914
// MTC 11817271
// CIIT 48953107
// VRAX 30038796
// VIVK 18243003
// SDOT 36775066
// MAPS 23464091
// PETZ 7963108
// CLPS 9936974
// JBDI 44227855
// EDTK 18526657
// TOMZ 19545048
// WGRX 47775262
// GIFT 44333115
// SFWL 34783073
// NAMI 46566630
// OSRH 47701956
// ZBAO 41615936
// VCIG 34609480
// LSB 42445028
// KITT 33713777
// CGTL 46061257
// CBAT 11451342
// MSPR 46241930
// TLIH 50641781
// PRPL 9903981
// IFBD 22662148
// PMCB 1437083
// ZCMD 18667051
// ICCM 32289865
// NWGL 37597524
// BLNK 9668299
// CMND 33551384
// LPSN 41967
// YGMZ 20438062
// RMTI 42300
// FGL 45345131
// SMXT 40703247
// CISO 26890106
// MOBX 46458047
// SGLY 26765132
// UK 21099648
// INLF 47168616
// FEBO 39061746
// IMTE 9773455
// MASK 47168625
// MNDR 41463561
// OCGN 15058499
// JCSE 28690855
// TIRX 21308787
// CHRS 1437120
// GLBS 49503
// ANTX 28271634
// BFRI 25576711
// LXRX 44197
// SKYX 29411806
// JZXN 23321972
// CCTG 39942609
// TVGN 41442717
// ONCY 158145
// LUCD 26130402
// TNON 28737218
// GAME 23681394
// GRWG 17228683
// PSNY 29876691
// AACG 15190224
// CGC 20073020
// CMMB 21972422
// DYAI 46889
// HYPR 27894255
// IMUX 13558261
// SELX 40692016
// SEED 24886
// TGL 30668987
// GRYP 40366992
// ISPC 26054652
// ALLR 26613524
// XWEL 32065407
// AKTX 2570295
// INEO 49231846
// NXL 32535001
// WFF 48509390
// KLTO 44590567
// SGRP 18880649
// STKH 30564318
// EM 22671250
// GERN 7407
// NWTN 32394653
// SIDU 26372305
// AREC 19507609
// MNTS 24383648
// SCKT 53745
// PDSB 13342348
// POWW 21278259
// TXMD 8035502
// IXHL 28014267
// SOWG 21049850
// IRD 45382785
// ADTX 19640605
// WTO 37444623
// MWYN 48782757
// REKR 14737785
// TOP 29411542
// PALI 22678845
// CLWT 25577
// HKPD 47168622
// HUDI 23954797
// ENLV 13404157
// MVIS 20370
// INTJ 41210098
// WYHG 46061238
// SOPA 25840538
// ELBM 31039404
// MYPS 23600440
// ONFO 29931206
// TYGO 35930917
// MRM 21308849
// PYXS 33178091
// LXEH 19481389
// RNXT 24956371
// SNAL 32336422
// KNDI 42385
// DXST 47168631
// ENVB 20719592
// IGMS 14943222
// GXAI 39954530
// CETX 4736038
// AEMD 39853
// XCH 44589847
// AKAN 28004558
// AMIX 40173716
// DLPN 8570472
// RELI 21700105
// ATPC 38128817
// BITF 23606889
// SXTP 36018862
// HOTH 12780925
// AMOD 47294839
// BEAT 28649975
// EVGN 6288759
// RDZN 43091185
// SNGX 39935
// VSA 48708895
// OMH 34599073
// GFAI 25687061
// RDGT 47931272
// VSME 38112925
// FPAY 10948645
// XHG 42504144
// MDIA 16041580
// DSY 43442552
// MYSZ 6288558
// FATE 559369
// RXT 18605889
// USEG 9565
// IINN 24633697
// VSEE 42993624
// XPON 28368758
// ATER 22750589
// EDUC 378197
// RDI 44507
// OPK 4365975
// HOWL 23147517
// BON 24802519
// SUUN 44791309
// CERS 39514
// RMCO 38609436
// TBH 48137557
// WRAP 20270139
// ARAY 28796
// GPRO 969030
// ANTE 14074932
// AREB 27314953
// DXLG 311457
// GIPR 27147405
// HKIT 34775942
// INHD 39306951
// LBGJ 46626143
// ANL 38284581
// TDTH 44845092
// WAFU 19161803
// BGFV 43723
// RNTX 46885429
// LAB 28391103
// MNDO 57080
// NNDM 5454837
// NVX 27381128
// AEI 21646918
// ACRV 41637934
// LVTX 22357182
// PEPG 28929493
// GIGM 6317
// HWH 41442570
// GEVO 51134
// VFF 13281490
// THAR 37882342
// VYNE 19102024
// ZNTL 17449828
// ALLO 11009185
// OLPX 25204968
// MNOV 44219
// ABOS 23999022
// PMEC 38115808
// GV 38112032
// LGO 22556426
// OGI 13876342
// GTIM 1437084
// CAPT 46092899
// INO 1140242
// PRFX 21320989
// BFRG 33490968
// DWSN 12045
// PMVP 21210454
// ZENV 22958838
// ARBE 25344340
// SNDL 14610920
// DCGO 25795822
// PLRZ 46458558
// YIBO 43914540
// CGEN 11532
// INBS 32113112
// BTBD 28160018
// EDAP 49545
// INCR 24673893
// IRIX 550273
// HMR 47634750
// BLIN 10188624
// CAPS 35059
// PNBK 672678
// COCH 37996740
// SBFM 207071
// MIST 13989337
// CTXR 11777919
// XELB 13864684
// PGEN 16254201
// MRKR 11043850
// CRDL 24407666
// SWAG 32923305
// BRLT 25128608
// ECX 33066538
// BRNS 38619229
// BRTX 24349144
// PLRX 17927888
// ADV 19812829
// CNET 50295
// JUNS 31286296
// CTNT 36844582
// OLB 23767964
// USEA 30045027
// BTOC 47748081
// CBUS 35772648
// HIT 46563376
// RPTX 18066817
// FTHM 18881003
// VANI 31050126
// NXXT 47575070
// CASI 946728
// BJDX 25840443
// CLYM 44981457
// GMGI 4062533
// SYBX 7710421
// WLDS 31281172
// ESPR 427587
// ADGM 47315515
// HOVR 45715553
// TRAW 41398061
// ZURA 34647994
// GANX 22571311
// EJH 24211206
// LGVN 21701131
// MGIH 34746424
// IMRN 7156485
// HIHO 163149
// COCP 802437
// JFU 14677492
// LOOP 8593912
// PACB 49377
// RDHL 1422201
// YHC 46357805
// XTLB 12055955
// SANW 130780
// GREE 24891520
// ACRS 2904478
// BTAI 9252727
// KIRK 37620
// SUNE 45901101
// ERAS 24569035
// MGNX 479079
// VEEA 44590569
// OMEX 28648
// MGRX 34599067
// APM 14086544
// CABA 15470730
// FRGT 29364691
// VRAR 24121583
// SAFX 50193090
// SEAT 25527327
// JZ 31002440
// REFR 14686419
// MIRA 36924996
// GTEC 18676512
// XTKG 40152340
// PLUG 1233
// FARM 43831
// ATLN 42903612
// MEGL 30598415
// OFAL 50052123
// SKIN 22830641
// TRSG 41867894
// CHR 38663584
// IKT 22043239
// MOGO 18444080
// HAIN 7191
// QSI 23433360
// ABVE 43142541
// GNSS 15263517
// KBSX 48224983
// KMRK 50792160
// MREO 13673397
// PRZO 33066527
// INVZ 22304437
// SLS 8640508
// IMMP 8435366
// PSHG 17144534
// RMCF 339245
// USIO 14231764
// BAER 34084219
// CSTE 155962
// QNCX 30540018
// PTNM 50135365
// BMEA 34715974
// LEDS 49625
// FAMI 9083223
// STFS 46134809
// WHWK 48236838
// YJ 13744285
// CRIS 5625
// FLUX 18889230
// HOUR 26797734
// PODC 37444277
// AGAE 32686628
// UONE 18019559
// WNW 20650380
// AGH 47578615
// FOSL 7179
// ALEC 12044492
// APWC 265835
// BHAT 17598743
// STAK 48987338
// BNRG 29291259
// SNTG 24043735
// INTZ 19993230
// APRE 15117532
// LRE 33613041
// PLBY 21351936
// WKHS 6899677
// CTOR 46277000
// OCTO 34804467
// HRTX 622697
// SNTI 31746601
// IMAB 16124879
// TLSA 11564321
// KLTR 24064968
// AHG 26407459
// GDTC 34960843
// GELS 48396333
// NIXX 44920794
// OXBR 8143945
// WETO 49894793
// ERNA 31908788
// IQ 9323234
// AIXI 34380661
// TCRX 25132537
// CREG 43887
// CDT 37882337
// MBIO 7877039
// SSKN 3128494
// NWTG 48200149
// RR 38741727
// TELA 16394904
// FORA 21696152
// TRUE 886940
// BYSI 7920899
// CVGI 44055
// GLMD 766247
// MYNZ 25797377
// KOPN 7206
// KLXE 10772061
// FBIO 1823119
// IHRT 14601228
// IPM 46756658
// ADAG 21563369
// ADN 21278154
// ELUT 37503005
// NRSN 27699195
// DGLY 298805
// OTLK 11462125
// GOSS 12054669
// MCHX 23331
// SYPR 19077320
// GUTS 40236909
// KIDZ 49137743
// NLSP 21777233
// SND 5838584
// ONDS 20926697
// BLDP 1074
// IPA 22043173
// SCNX 44764999
// CNTB 25454181
// YQ 20338975
// BDMD 46700506
// MNY 38196360
// JWEL 24827136
// GTBP 7885811
// NXTT 41377447
// SHIM 38569848
// CRON 9140177
// OABI 32183553
// NCI 41829258
// NTCL 46566761
// BOXL 9749547
// QRHC 11493417
// XTIA 40987156
// NIPG 43602186
// NERV 1225029
// GRI 35143636
// TANH 1762422
// DTSS 15263622
// EGHT 32407118
// LMFA 6330406
// LUCY 28737206
// TELO 46163982
// STRR 20738352
// FNGR 26602474
// IVDA 24738922
// HLVX 28787634
// XFOR 13291802
// SOND 27082004
// CLNE 28008
// CURR 44440784
// GEG 20670375
// IVF 49231839
// LVRO 34178580
// NNBR 44255
// NOTV 22088075
// VERI 7009276
// GRNQ 11492680
// HGBL 444598
// SAGT 49264897
// DUO 15914344
// EFOI 32743
// POLA 5787327
// QIPT 23861848
// AAME 106821
// BLNE 47208586
// ORMP 42719
// IPHA 24986430
// LOT 40664078
// TAIT 1069392
// SEER 20338964
// ENTX 8827401
// VUZI 170726
// NKTX 18335948
// QTTB 41283111
// CCCC 19501187
// BCG 50582273
// JAGX 2904482
// VIVS 49188827
// HIVE 24883198
// EXFY 25840454
// BMGL 47807521
// NXGL 26568928
// RMSG 46071114
// TURB 37856227
// AWRE 5994
// FMST 46805865
// PRQR 2335073
// SDA 35561559
// BCDA 18514953
// CTRM 13404778
// DTI 40895382
// FLNT 9506542
// VRA 49372
// CRBU 24093484
// HITI 23250746
// MXCT 24281518
// ENSC 23784215
// MNTK 21073924
// PPBT 20592593
// SPRO 8198463
// CMTL 14956
// OPEN 20579517
// LIQT 13562074
// NMRA 38004289
// VEEE 30721268
// SMX 34892858
// OXSQ 9343517
// INAB 26901214
// RETO 10002712
// CRNT 9422
// QMMM 43493908
// OKUR 45034445
// DLTH 3005957
// AGMH 9936712
// CLGN 21222207
// UCAR 34966197
// EDSA 14036063
// CTMX 2904480
// VOR 21296737
// CDLX 9020523
// NVFY 728055
// NSPR 23090187
// YYGH 41805322
// SAVA 13436092
// BZFD 26246355
// MDCX 46092799
// MURA 38757808
// ACIU 5062494
// AXTI 5604
// FAT 8135339
// IPDN 367258
// CCLD 33297989
// IOBT 25942623
// ZKIN 7878008
// APYX 11719770
// SVRE 28737214
// VS 22043174
// HUMA 24631844
// CARV 9773452
// GROW 8382
// OPAL 30384494
// MAMK 50610573
// HEPS 23758706
// UTSI 2755
// RMBL 8089277
// AUTL 10738415
// ANNX 18526702
// DARE 7410076
// MGX 40405568
// MDXH 38284465
// PHIO 11355153
// RAY 42390602
// CNEY 22323684
// CNTY 30021
// ZYXI 33562
// HUIZ 21338745
// VERO 15443496
// MCTR 47089716
// DATS 24580705
// LWLG 21257138
// FTFT 7149827
// CPSH 497444
// BEEM 19202284
// LPRO 18009873
// MAMO 41377743
// GMM 38122120
// RIME 44428665
// GITS 46377721
// SABS 25592819
// INM 20173717
// UPLD 2852852
// FATBB 24555207
// JDZG 42322355
// AIMD 23136206
// AYTU 3126867
// CELZ 19101010
// FFAI 48063683
// TSHA 19383402
// BOF 44271452
// SHMD 50698934
// UFG 48782750
// GSUN 30734481
// IBRX 21868421
// MRVI 20173543
// ADVM 4131008
// CJET 35915622
// SVRA 6829195
// ACHV 7547931
// BSLK 44235134
// FTEK 16373
// QLGN 17763735
// REVB 26795750
// MDAI 37882855
// IMMX 26510595
// HBNB 50524172
// LSTA 31339727
// TUSK 6431571
// OKYO 29085378
// WXM 50418578
// ISPO 27893440
// CNDT 15848140
// LGCB 39413665
// UOKA 46120626
// ALZN 23538370
// HURA 45243900
// BZUN 1940481
// DIBS 23368290
// IMCC 49941741
// RSSS 21556960
// ICG 34794221
// LCID 24093536
// BWEN 31783
// CIGL 50708545
// REBN 30732131
// SINT 11228102
// MSW 46888213
// RCT 49964757
// CREX 1153335
// CYCN 13447285
// IDAI 25539530
// IMDX 50230861
// ASRV 7300537
// CLLS 1708603
// SURG 21257202
// XBIT 1764912
// ICMB 14788932
// TLS 20138316
// THCH 32157819
// LHSW 48588750
// UCL 25241894
// CRWS 48199
// EVAX 21191456
// KLRS 48237345
// GLE 44780271
// BRLS 41511696
// CWD 35479289
// ESGL 37067823
// INMB 15524794
// RCON 39640
// KPRX 25795824
// ELWS 36810260
// LASE 31648212
// MBOT 5590883
// AIFF 43935677
// UROY 22767303
// RAVE 1439116
// DEFT 49488258
// APVO 4728494
// CDZI 42451
// IOVA 7257701
// PLUT 47492365
// NRXP 23146964
// BDTX 16411943
// SVC 15014529
// FCUV 24713762
// RZLV 44698152
// ZSPC 46194728
// BBLG 26788869
// CLOV 20836791
// NB 38979543
// RBNE 48952713
// ENGS 48588747
// HFFG 20929511
// LGHL 20855953
// ABSI 24667265
// BAOS 21678381
// TEAD 50084049
// BTCT 37977972
// DRTS 28187807
// SGMA 3113776
// EDIT 3443165
// ARTV 43444834
// BTBT 18645926
// EU 39626206
// KTCC 358558
// TORO 34287342
// GRCE 45431917
// VTYX 25576709
// ''';
