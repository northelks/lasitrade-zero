import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/models/trade_model.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/models/db/db_hist_model.dart';
import 'package:lasitrade/shadcn.dart';
import 'package:lasitrade/theme.dart';
import 'package:lasitrade/viewmodels/instrument_viewmodel.dart';
import 'package:lasitrade/widgets/buttons/mouse_button.dart';
import 'package:lasitrade/widgets/empty.dart';

class ChartScreen extends StatefulWidget {
  final bool isD1;
  final int inx;
  final bool isTp;

  const ChartScreen({
    super.key,
    required this.isD1,
    required this.inx,
    required this.isTp,
  });

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen>
    with TickerProviderStateMixin {
  TradeModel? currTrade;

  GChart? gChart;

  List<DBHistModel> hists = [];
  late GDataSource<int, GData<int>> dataSource;

  late GValueAxisMarker gValueAxisMarkerLatest;
  late GValueAxisMarker gValueAxisMarkerSl;
  late GValueAxisMarker gValueAxisMarkerOp;

  late GPolyLineMarker gPolyLineMarkerLatest;
  late GPolyLineMarker gPolyLineMarkerSl;
  late GPolyLineMarker gPolyLineMarkerOp;

  late GShapeMarker gMarketOpPoint;

  late GPointViewPort gPointViewPort;
  late GValueViewPort gValueViewPort;

  int maxVol = 0;
  double y = 0;

  int opPoint = 0;

  @override
  void initState() {
    super.initState();

    reDataSource();
    reBuildChart();
    reRenderChart();

    tradeVM.addListener(() {
      reDataSource();
      reRenderChart(repaint: true);
    });
  }

  @override
  void didChangeDependencies() {
    context.watch<InstrumentViewModel>();

    reDataSource();
    reBuildChart();
    reRenderChart();

    super.didChangeDependencies();
  }

  int get currUic => widget.isTp ? instVM.currUic : instVM.currUicN(widget.inx);

  void reDataSource() {
    if (widget.isTp) {
      final currPosition = tradeVM.positionOf(currUic);
      if (currPosition != null) {
        currTrade = tradeVM.buildPositionTrade(currPosition);
      } else {
        final currOrder = tradeVM.orderOf(currUic);
        if (currOrder != null) {
          currTrade = tradeVM.buildOrderTrade(currOrder);
        } else {
          currTrade = tradeVM.buildPreTrade(currUic)!;
        }
      }
    }

    final currInstrumentHists5Min = widget.isTp
        ? histVM.currInstrumentHists5Min
        : histVM.currInstrumentHistsN5Min(widget.inx);

    hists =
        widget.isD1 ? histVM.currInstrumentHists1Day : currInstrumentHists5Min;

    if (widget.isD1) {
      final dayHist = DBHistModel.aggregateToday(currInstrumentHists5Min);

      if (dayHist != null) {
        hists.last.open = dayHist.open;
        hists.last.high = dayHist.high;
        hists.last.low = dayHist.low;
        hists.last.close = dayHist.close;
        hists.last.volume = dayHist.volume;
      }
    }

    dataSource = GDataSource<int, GData<int>>(
      dataList: hists.map((candle) {
        return GData<int>(
          pointValue: candle.timeAt.millisecondsSinceEpoch,
          seriesValues: [
            candle.open,
            candle.high,
            candle.low,
            candle.close,
            candle.volume.toDouble(),
          ],
        );
      }).toList(),
      seriesProperties: const [
        GDataSeriesProperty(key: 'open', label: 'Open', precision: 2),
        GDataSeriesProperty(key: 'high', label: 'High', precision: 2),
        GDataSeriesProperty(key: 'low', label: 'Low', precision: 2),
        GDataSeriesProperty(key: 'close', label: 'Close', precision: 2),
        GDataSeriesProperty(key: 'volume', label: 'Volume', precision: 0),
      ],
    );

    //~

    if (!widget.isD1 &&
        widget.isTp &&
        currTrade!.position != null &&
        currTrade!.uic == currUic) {
      for (var hist in hists) {
        final diff = hist.timeAt
            .difference(currTrade!.position!.executionTimeOpen)
            .inMinutes;
        if (diff > 0 && opPoint == 0) {
          opPoint = hists.indexOf(hist);
        }
      }
    }

    double? lastTraded;
    lastTraded = widget.isTp
        ? infoPriceVM.curreInfoPrice?.lastTraded
        : infoPriceVM.infoPriceOf(currUic)!.lastTraded;

    if (lastTraded != null && widget.isTp) {
      y = lastTraded;
    } else if (hists.isNotEmpty) {
      y = hists.last.close;
    }
  }

  void reRenderChart({bool repaint = false}) {
    double? lastTraded;
    lastTraded = widget.isTp
        ? infoPriceVM.curreInfoPrice?.lastTraded
        : infoPriceVM.infoPriceOf(currUic)!.lastTraded;

    if (lastTraded != null && widget.isTp) {
      y = lastTraded;
    } else if (hists.isNotEmpty) {
      y = hists.last.close;
    }

    gPolyLineMarkerLatest.keyCoordinates[0] =
        (gPolyLineMarkerLatest.keyCoordinates[0] as GCustomCoord).copyWith(
      y: y,
    );

    gPolyLineMarkerLatest.keyCoordinates[1] =
        (gPolyLineMarkerLatest.keyCoordinates[1] as GCustomCoord).copyWith(
      y: y,
    );

    if (currTrade != null) {
      gPolyLineMarkerSl.keyCoordinates[0] =
          (gPolyLineMarkerSl.keyCoordinates[0] as GCustomCoord).copyWith(
        y: currTrade!.sl,
      );

      gPolyLineMarkerSl.keyCoordinates[1] =
          (gPolyLineMarkerSl.keyCoordinates[1] as GCustomCoord).copyWith(
        y: currTrade!.sl,
      );

      gPolyLineMarkerOp.keyCoordinates[0] =
          (gPolyLineMarkerOp.keyCoordinates[0] as GCustomCoord).copyWith(
        y: currTrade!.op,
      );

      gPolyLineMarkerOp.keyCoordinates[1] =
          (gPolyLineMarkerOp.keyCoordinates[1] as GCustomCoord).copyWith(
        y: currTrade!.op,
      );
    }

    //~

    gValueAxisMarkerLatest.labelValue = y;

    if (currTrade != null) {
      gValueAxisMarkerSl.labelValue = currTrade!.sl;
      gValueAxisMarkerOp.labelValue = currTrade!.op;

      gMarketOpPoint.keyCoordinates[0] =
          (gMarketOpPoint.keyCoordinates[0] as GViewPortCoord).copyWith(
        point: opPoint.toDouble(),
        value: currTrade!.op,
      );
    }

    maxVol = 0;
    for (var it in hists) {
      if (it.volume > maxVol) {
        maxVol = it.volume;
      }
    }

    if (repaint) {
      gChart?.autoScaleViewports();

      setState(() {
        gChart?.repaint();
      });
    }
  }

  void reBuildChart() {
    gPolyLineMarkerLatest = GPolyLineMarker(
      id: "line-marker-latest",
      theme: GOverlayMarkerTheme(
        markerStyle: PaintStyle(
          strokeColor: AppTheme.clYellow,
          strokeWidth: 0.8,
          dash: [8, 3],
        ),
        controlHandleThemes: {},
      ),
      coordinates: [
        GCustomCoord(
          x: 0.0,
          y: y,
          coordinateConvertor: kCoordinateConvertorXPositionYValue,
          coordinateConvertorReverse:
              kCoordinateConvertorXPositionYValueReverse,
        ),
        GCustomCoord(
          x: 1.0,
          y: y,
          coordinateConvertor: kCoordinateConvertorXPositionYValue,
          coordinateConvertorReverse:
              kCoordinateConvertorXPositionYValueReverse,
        ),
      ],
    );

    gPolyLineMarkerSl = GPolyLineMarker(
      id: "line-marker-sl",
      theme: GOverlayMarkerTheme(
        markerStyle: PaintStyle(
          strokeColor: AppTheme.clRed,
          strokeWidth: 1,
          dash: [3, 3],
        ),
        controlHandleThemes: {},
      ),
      coordinates: [
        if (currTrade != null)
          GCustomCoord(
            x: 0.0,
            y: currTrade!.sl,
            coordinateConvertor: kCoordinateConvertorXPositionYValue,
            coordinateConvertorReverse:
                kCoordinateConvertorXPositionYValueReverse,
          ),
        if (currTrade != null)
          GCustomCoord(
            x: 1.0,
            y: currTrade!.sl,
            coordinateConvertor: kCoordinateConvertorXPositionYValue,
            coordinateConvertorReverse:
                kCoordinateConvertorXPositionYValueReverse,
          ),
      ],
    );

    gPolyLineMarkerOp = GPolyLineMarker(
      id: "line-marker-op",
      theme: GOverlayMarkerTheme(
        markerStyle: PaintStyle(
          strokeColor: AppTheme.clBlue,
          strokeWidth: 1,
          dash: [3, 3],
        ),
        controlHandleThemes: {},
      ),
      coordinates: [
        if (currTrade != null)
          GCustomCoord(
            x: 0.0,
            y: currTrade!.op,
            coordinateConvertor: kCoordinateConvertorXPositionYValue,
            coordinateConvertorReverse:
                kCoordinateConvertorXPositionYValueReverse,
          ),
        if (currTrade != null)
          GCustomCoord(
            x: 1.0,
            y: currTrade!.op,
            coordinateConvertor: kCoordinateConvertorXPositionYValue,
            coordinateConvertorReverse:
                kCoordinateConvertorXPositionYValueReverse,
          ),
      ],
    );

    //~

    gValueAxisMarkerLatest = GValueAxisMarker.label(
      id: "axis-marker-latest",
      theme: GAxisMarkerTheme(
        labelTheme: GAxisLabelTheme(
          labelStyle: LabelStyle(
            backgroundStyle: PaintStyle(
              fillColor: Colors.black,
            ),
            backgroundCornerRadius: 4,
            backgroundPadding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 4,
            ),
            textStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ),
      ),
      labelValue: y,
    );

    gValueAxisMarkerSl = GValueAxisMarker.label(
      id: "axis-marker-sl",
      theme: GAxisMarkerTheme(
        labelTheme: GAxisLabelTheme(
          labelStyle: LabelStyle(
            backgroundStyle: PaintStyle(
              fillColor: Colors.black,
            ),
            backgroundCornerRadius: 4,
            backgroundPadding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 4,
            ),
            textStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppTheme.clRed,
            ),
          ),
        ),
      ),
      labelValue: currTrade?.sl ?? 0.0,
    );

    gValueAxisMarkerOp = GValueAxisMarker.label(
      id: "axis-marker-op",
      theme: GAxisMarkerTheme(
        labelTheme: GAxisLabelTheme(
          labelStyle: LabelStyle(
            backgroundStyle: PaintStyle(
              fillColor: Colors.black,
            ),
            backgroundCornerRadius: 4,
            backgroundPadding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 4,
            ),
            textStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppTheme.clBlue,
            ),
          ),
        ),
      ),
      labelValue: currTrade?.op ?? 0.0,
    );

    //~

    gMarketOpPoint = GShapeMarker(
      anchorCoord: GViewPortCoord(
        point: opPoint.toDouble(),
        value: currTrade?.op ?? 0.0,
      ),
      radiusSize: GSize.pointSize(5),
      pathGenerator: (r) => GShapes.circle(5),
    );

    //~

    gPointViewPort = GPointViewPort(
      autoScaleStrategy: const GPointViewPortAutoScaleStrategyLatest(
        endSpacingPoints: 5,
      ),
      defaultPointWidth: widget.isD1 ? 10 : (widget.isTp ? 4 : 4),
    );

    gValueViewPort = GValueViewPort(
      valuePrecision: 2,
      autoScaleStrategy: GValueViewPortAutoScaleStrategyMinMax(
        dataKeys: ["high", "low"],
        marginStart: GSize.viewHeightRatio(0.2),
      ),
    );

    gChart = GChart(
      dataSource: dataSource,
      pointViewPort: gPointViewPort,
      theme: GThemeDark(),
      panels: [
        GPanel(
          theme: GPanelTheme(
            style: PaintStyle(strokeColor: Colors.transparent),
          ),
          valueViewPorts: [
            gValueViewPort,
            GValueViewPort(
              id: "volumeViewPort",
              valuePrecision: 0,
              autoScaleStrategy: GValueViewPortAutoScaleStrategyMinMax(
                dataKeys: ["volume"],
                marginEnd: GSize.viewHeightRatio(0.8),
                marginStart: GSize.viewHeightRatio(0.0),
              ),
            ),
          ],
          valueAxes: [
            GValueAxis(
              size: 50,
              theme: GAxisTheme(
                lineStyle: PaintStyle(
                  strokeColor: Colors.black,
                  strokeWidth: 2,
                ),
                tickerStyle: PaintStyle(
                  strokeColor: Colors.black,
                  strokeWidth: 2,
                ),
                selectionStyle: PaintStyle(),
                labelTheme: GAxisLabelTheme(
                  spacing: 10,
                  labelStyle: LabelStyle(
                    textStyle: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              axisMarkers: [
                gValueAxisMarkerSl,
                if (!widget.isD1 &&
                    widget.isTp &&
                    (currTrade!.order != null || currTrade!.position != null))
                  gValueAxisMarkerOp,
                gValueAxisMarkerLatest,
              ],
            ),
            GValueAxis(
              id: "volume",
              position: GAxisPosition.startInside,
              scaleMode: GAxisScaleMode.none,
              valueFormatter: (value, precision) {
                if (value > maxVol) return '';

                if (value >= 1000000) {
                  return '${(value / 1000000).toStringAsFixed(1)}M';
                } else if (value >= 1000) {
                  return '${(value / 1000).toStringAsFixed(1)}K';
                } else {
                  return value.toStringAsFixed(0);
                }
              },
              theme: GAxisTheme(
                lineStyle: PaintStyle(),
                tickerStyle: PaintStyle(),
                selectionStyle: PaintStyle(),
                labelTheme: GAxisLabelTheme(
                  labelStyle: LabelStyle(
                    textStyle: TextStyle(
                      fontSize: 10,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          ],
          pointAxes: [
            GPointAxis(
              size: 30,
              pointTickerStrategy: GPointTickerStrategyDefault(
                tickerMinSize: widget.isD1 ? 100 : 100,
              ),
              pointFormatter: (int a, dynamic b) {
                final sr = DateTime.fromMillisecondsSinceEpoch(b);

                String df = 'dd MMM';
                if (widget.isD1) {
                  df += ', yy';
                }

                return DateFormat(df).format(sr);
              },
              theme: GAxisTheme(
                lineStyle: PaintStyle(
                  strokeColor: Colors.black,
                  strokeWidth: 1,
                ),
                tickerStyle: PaintStyle(
                  strokeColor: Colors.white60,
                  strokeWidth: 1,
                ),
                selectionStyle: PaintStyle(),
                labelTheme: GAxisLabelTheme(
                  spacing: 10,
                  labelStyle: LabelStyle(
                    textStyle: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
            if (!widget.isD1)
              GPointAxis(
                size: 30,
                pointFormatter: (int a, dynamic b) {
                  final sr = DateTime.fromMillisecondsSinceEpoch(b);

                  return DateFormat('HH:mm').format(sr);
                },
                theme: GAxisTheme(
                  lineStyle: PaintStyle(
                    strokeColor: Colors.black,
                    strokeWidth: 2,
                  ),
                  tickerStyle: PaintStyle(
                    strokeColor: Colors.black,
                    strokeWidth: 2,
                  ),
                  selectionStyle: PaintStyle(),
                  labelTheme: GAxisLabelTheme(
                    spacing: 10,
                    labelStyle: LabelStyle(
                      textStyle: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ),
          ],
          graphs: [
            GGraphGrids(
              theme: GGraphGridsTheme(
                lineStyle: PaintStyle(
                  strokeColor: Colors.white10,
                ),
              ),
            ),
            GGraphOhlc(
              ohlcValueKeys: const ["open", "high", "low", "close"],
              theme: GGraphOhlcTheme(
                barStylePlus: PaintStyle(
                  fillColor: Colors.green,
                  strokeWidth: 1,
                ),
                barStyleMinus: PaintStyle(
                  fillColor: Colors.red,
                  strokeWidth: 1,
                ),
              ),
              overlayMarkers: [
                gPolyLineMarkerSl,
                if (!widget.isD1 &&
                    widget.isTp &&
                    (currTrade!.order != null || currTrade!.position != null))
                  gPolyLineMarkerOp,
                if (!widget.isD1 && opPoint != 0) gMarketOpPoint,
                gPolyLineMarkerLatest,
              ],
            ),
            GGraphBar(
              valueKey: "volume",
              valueViewPortId: "volumeViewPort",
              baseValue: 0,
              theme: GGraphBarTheme(
                barStyleAboveBase: PaintStyle(
                  fillColor: Colors.grey.shade800,
                ),
                barStyleBelowBase: PaintStyle(
                  fillColor: Colors.grey.shade800,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget chartAppEmpty = Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2),
      ),
      child: Center(
        child: AppMouseButton(
          onTap: () async {
            // final res = await instServ.getInstrumentHistorical(
            //   uic: widget.currUic,
            //   horizon: Horizon.m5,
            // );

            // final res2 = await instServ.getInstrumentHistorical(
            //   uic: widget.currUic,
            //   horizon: Horizon.d1,
            // );

            // final res23 = await instServ.getInstrumentHistoricalFull(
            //   uic: widget.currUic,
            //   horizon: Horizon.m5,
            //   fromDt: DateTime(
            //     DateTime.now().year,
            //     DateTime.now().month - 3,
            //     1,
            //   ),
            // );

            // final aaa = await psqlServ.insertHists(
            //   hists: res23,
            //   horizon: Horizon.m5,
            // );

            // final res2333 = await instServ.getInstrumentHistoricalFull(
            //   uic: widget.currUic,
            //   horizon: Horizon.d1,
            // );
          },
          child: AppEmpty(),
        ),
      ),
    );

    if (gChart == null) return chartAppEmpty;

    if (hists.isEmpty) {
      return chartAppEmpty;
    }

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(width: 2),
      ),
      child: Stack(
        children: [
          GChartWidget(
            onPointerDown: (event) {
              // print(event);
            },
            chart: gChart!,
            tickerProvider: this,
          ),
          Builder(builder: (context) {
            return Positioned(
              left: 0,
              top: 0,
              child: Row(
                children: [
                  // AppMouseButton(
                  //   onTap: () {
                  //     if (appVM.tab != cstTabs['hists']!) {
                  //       appVM.tab = cstTabs['hists']!;
                  //       appVM.notify();
                  //     }
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 11,
                  //       vertical: 4,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       color: Colors.deepOrange.shade900
                  //           .withOpacity(saxoLast == dbLast ? 0.7 : 0.4),
                  //       borderRadius: BorderRadius.all(Radius.circular(4)),
                  //     ),
                  //     child: Icon(
                  //       saxoLast == dbLast
                  //           ? BootstrapIcons.databaseCheck
                  //           : BootstrapIcons.database,
                  //       size: 14,
                  //       color: saxoLast == dbLast
                  //           ? AppTheme.clText
                  //           : AppTheme.clText,
                  //     ),
                  //   ),
                  // ),
                  // 8.w,
                  AppMouseButton(
                    onTap: () async {
                      // Rect area = gChart!.panels[0].graphArea();
                      // gPointViewPort.zoom(area, 0.5);
                      // return;

                      reBuildChart();
                      setState(() {});

                      // for (var it in List.generate(10, (i) => i)) {
                      //   infoPriceVM.notify();
                      //   await Future.delayed(2000.mlsec);
                      // }

                      // gViewPort.zoom(gChart!.panels[0].graphArea(), 1.5);

                      // final viewPort = gChart!.panels[0]
                      //     .findValueViewPortById("'high-low-viewport'");

                      // gPointViewPort.autoScaleFlg = false;
                      // gChart!.autoScaleViewports(
                      //   resetValueViewPort: false,
                      // );

                      //~

                      // int amount = 10;
                      // double orderPrice = 3.30;
                      // double slPrice = double.parse(
                      //     (orderPrice - orderPrice / 100 * 4)
                      //         .toStringAsFixed(2));
                      // double trailingStopStep =
                      //     double.parse((orderPrice / 100).toStringAsFixed(2));

                      // final aa = await tradeServ.placeBuyOrder(
                      //   uic: widget.currUic,
                      //   amount: amount,
                      //   orderPrice: orderPrice,
                      //   slPrice: slPrice,
                      //   trailingStopStep: trailingStopStep,
                      //   precheck: true,
                      // );

                      //~

                      // final a = gPointViewPort.range;

                      // gPointViewPort.animateToRange(
                      //   GRange.range(-43.7, 120),
                      //   true,
                      //   true,
                      // );
                      // print(a);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade900.withOpacity(0.3),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Icon(
                        BootstrapIcons.arrowClockwise,
                        size: 14,
                        color: AppTheme.clText,
                      ),
                    ),
                  ),
                  6.w,
                  AppMouseButton(
                    onTap: () async {
                      await instVM.setInstrumentByUic(currUic);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade900.withOpacity(
                            currUic == instVM.currUic && !widget.isTp
                                ? 0.8
                                : 0.3),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Text(
                        instVM.instrumentOf(currUic)!.symbol,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.clText07,
                        ),
                      ),
                    ),
                  ),
                  6.w,
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
