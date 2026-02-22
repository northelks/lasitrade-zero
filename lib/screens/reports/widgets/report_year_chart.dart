import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lasitrade/models/saxo/saxo_closed_position_model.dart';
import 'package:lasitrade/theme.dart';

class ReportYearChart extends StatelessWidget {
  final List<SaxoClosedPositionModel> data;

  const ReportYearChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];

    for (var nM in List.generate(12, (i) => i)) {
      final dataMonth = data.where((it) {
        return it.tradeDate?.month == nM + 1;
      }).toList();

      final resMonth = dataMonth.fold(
        0.0,
        (acc, it) => acc += it.pnLUSD,
      );

      spots.add(FlSpot(nM.toDouble(), resMonth / 1000));
    }

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) {
              return Colors.transparent;
            },
            getTooltipItems: (touchedSpots) {
              final val = (touchedSpots.first.y * 1000);

              final textStyle = TextStyle(
                color: val < 0
                    ? AppTheme.clRed
                    : (val > 0 ? AppTheme.clGreen : AppTheme.clText),
                fontSize: 14,
              );

              return [
                LineTooltipItem(val.toStringAsFixed(1), textStyle),
              ];
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: value == 10 ? AppTheme.clYellow : AppTheme.clBlack,
              strokeWidth: 1,
              dashArray: [6, 6],
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: AppTheme.clBlack,
              strokeWidth: 1,
              dashArray: [6, 6],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 25,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final spot = spots.firstWhere((it) => it.x == value);

                return SideTitleWidget(
                  meta: meta,
                  space: 7,
                  fitInside: SideTitleFitInsideData(
                    enabled: true,
                    distanceFromEdge: -8,
                    parentAxisSize: 0,
                    axisPosition: 0,
                  ),
                  child: Text(
                    DateFormat('MMM').format(
                      DateTime(1990, (value + 1).toInt(), 1),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: spot.y < 0
                          ? AppTheme.clRed
                          : (spot.y > 0 ? AppTheme.clGreen : AppTheme.clText08),
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if ((value % 2) != 0) {
                  if (value != 12.0) return Container();
                }

                return Row(
                  children: [
                    Text(
                      value.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            value == 10 ? AppTheme.clYellow : AppTheme.clText08,
                        fontWeight:
                            value == 10 ? FontWeight.bold : FontWeight.normal,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 10, left: 1),
                      child: Text(
                        'k',
                        style: TextStyle(
                          fontSize: 10,
                          color: value == 10
                              ? AppTheme.clYellow
                              : AppTheme.clText08,
                          fontWeight:
                              value == 10 ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                );
              },
              reservedSize: 42,
            ),
          ),
        ),
        minX: 0,
        maxX: 11,
        minY: -2,
        maxY: 13.0,
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppTheme.clYellow,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.clYellow005,
            ),
          ),
        ],
      ),
    );
  }
}
