import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lasitrade/models/saxo/saxo_booking_model.dart';
import 'package:lasitrade/models/saxo/saxo_closed_position_model.dart';
import 'package:lasitrade/widgets/buttons/mouse_button.dart';
import 'package:lasitrade/widgets/progress_indicator.dart';

import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:lasitrade/viewmodels/report_viewmodel.dart';
import 'package:lasitrade/shadcn.dart';
import 'package:lasitrade/screens/reports/widgets/report_year_chart.dart';
import 'package:lasitrade/widgets/textfields/textfield.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/screens/reports/widgets/saxo_booking_report_grid.dart';
import 'package:lasitrade/screens/reports/widgets/saxo_closed_positions_report_grid.dart';
import 'package:lasitrade/theme.dart';
import 'package:lasitrade/utils/core_utils.dart';
import 'package:lasitrade/extensions.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late final AppDebouncer _debouncer;

  late final TextEditingController _symbolCtrl;

  bool _isYearChart = false;
  String _query = '';

  late DateTime _seletedDay;
  late int _selectedYear;

  bool _loadingUp = false;

  @override
  void initState() {
    _debouncer = AppDebouncer(delay: 500.mlsec);

    _symbolCtrl = TextEditingController();

    reportVM.reportTab = 0;

    _seletedDay = DateTime.now();
    _selectedYear = _seletedDay.year;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    context.watch<ReportViewModel>();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _debouncer.cancel();

    _symbolCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<SaxoClosedPositionModel> rClosedPositions = reportVM.rClosedPositions;
    List<SaxoBookingModel> rSaxoBookingModel = reportVM.rSaxoBookingModel;

    if (_query.isNotEmpty) {
      rClosedPositions = rClosedPositions
          .where((it) => it.symbol.toLowerCase().contains(_query.toLowerCase()))
          .toList();

      rSaxoBookingModel = rSaxoBookingModel
          .where((it) =>
              it.symbol?.toLowerCase().contains(_query.toLowerCase()) ?? false)
          .toList();
    }

    List<SaxoClosedPositionModel> rClosedPositionsOfDay =
        rClosedPositions.where((it) {
      return fnIsSameDay(it.tradeDate, _seletedDay);
    }).toList();

    //~

    final dataYear = rClosedPositions.where((it) {
      return it.tradeDate?.year == _selectedYear;
    }).toList();

    final resYear = dataYear.fold(
      0.0,
      (acc, it) => acc += it.pnLUSD,
    );

    return Container(
      // width: 752,
      // width: 600,
      height: context.height,
      padding: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      child: SizedBox(
        // width: 252 * 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: 40,
              child: Row(
                children: [
                  OutlineButton(
                    density: ButtonDensity.icon,
                    enabled: _selectedYear != 2024,
                    onPressed: () {
                      setState(() {
                        _selectedYear -= 1;
                      });
                    },
                    child: const Icon(Icons.arrow_back).iconXSmall(),
                  ),
                  20.w,
                  Text(
                    '$_selectedYear',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  20.w,
                  OutlineButton(
                    density: ButtonDensity.icon,
                    enabled: _selectedYear < DateTime.now().year,
                    onPressed: () {
                      setState(() {
                        _selectedYear += 1;
                      });
                    },
                    child: const Icon(Icons.arrow_forward).iconXSmall(),
                  ),
                  const Spacer(),
                  Center(
                    child: Tabs(
                      index: reportVM.reportTab,
                      children: const [
                        TabItem(child: Text('Calendar')),
                        TabItem(child: Text('Backlog')),
                        TabItem(child: Text('Bookings')),
                      ],
                      onChanged: (int value) {
                        setState(() {
                          reportVM.reportTab = value;
                        });
                      },
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 111,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppTheme.clBlack02,
                      border: Border.all(
                        width: 1,
                        color: AppTheme.clText01,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: AppTextField(
                      ctrl: _symbolCtrl,
                      focusNode: reportVM.reportInstFocusNode,
                      inputFormatters: [AppTextFieldUpperCaseTextFormatter()],
                      placeholder: 'Symbol',
                      fontSize: 16,
                      height: 32,
                      onChanged: (value) {
                        setState(() {
                          _query = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            15.h,
            // Container(
            //   padding: const EdgeInsets.only(left: 10, right: 10),
            //   child: 10.hrr(),
            // ),
            if (reportVM.reportTab == 0)
              Container(
                padding: const EdgeInsets.only(left: 20, right: 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        for (var n in [1, 2, 3]) ...[
                          ReportCalendarMonth(
                            year: _selectedYear,
                            month: n,
                            data: rClosedPositions,
                            selectedDay: _seletedDay,
                            onDaySelected: (selectedDay) {
                              setState(() {
                                _seletedDay = selectedDay;
                                _isYearChart = false;
                              });
                            },
                          ),
                          if (n != 3) 5.w,
                        ],
                      ],
                    ),
                    10.h,
                    Row(
                      children: [
                        for (var n in [4, 5, 6]) ...[
                          ReportCalendarMonth(
                            year: _selectedYear,
                            month: n,
                            data: rClosedPositions,
                            selectedDay: _seletedDay,
                            onDaySelected: (selectedDay) {
                              setState(() {
                                _seletedDay = selectedDay;
                                _isYearChart = false;
                              });
                            },
                          ),
                          if (n != 6) 5.w,
                        ],
                      ],
                    ),
                    10.h,
                    Row(
                      children: [
                        for (var n in [7, 8, 9]) ...[
                          ReportCalendarMonth(
                            year: _selectedYear,
                            month: n,
                            data: rClosedPositions,
                            selectedDay: _seletedDay,
                            onDaySelected: (selectedDay) {
                              setState(() {
                                _seletedDay = selectedDay;
                                _isYearChart = false;
                              });
                            },
                          ),
                          if (n != 9) 5.w,
                        ],
                      ],
                    ),
                    10.h,
                    Row(
                      children: [
                        for (var n in [10, 11, 12]) ...[
                          ReportCalendarMonth(
                            year: _selectedYear,
                            month: n,
                            data: rClosedPositions,
                            selectedDay: _seletedDay,
                            onDaySelected: (selectedDay) {
                              setState(() {
                                _seletedDay = selectedDay;
                                _isYearChart = false;
                              });
                            },
                          ),
                          if (n != 12) 5.w,
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            if (reportVM.reportTab == 1)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: SaxoClosedPositionsReportGrid(
                    data: rClosedPositions,
                    sortBy: [
                      ('Trade Date', 'desc'),
                    ],
                    onTap: (symbol) async {
                      final inst = instVM.instruments
                          .firstWhereOrNull((it) => it.symbol == symbol);
                      if (inst != null) {
                        await instVM.setInstrumentBySymbol(symbol);
                      }
                    },
                  ),
                ),
              ),
            if (reportVM.reportTab == 2)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: SaxoBookingReportGrid(
                    data: rSaxoBookingModel,
                    sortBy: [
                      ('Date', 'desc'),
                    ],
                    onTap: (symbol) async {
                      final inst = instVM.instruments
                          .firstWhereOrNull((it) => it.symbol == symbol);
                      if (inst != null) {
                        await instVM.setInstrumentBySymbol(symbol);
                      }
                    },
                  ),
                ),
              ),
            if (reportVM.reportTab == 0)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    right: 20,
                    left: 0,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 12, right: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (!_isYearChart) ...[
                              OutlineButton(
                                density: ButtonDensity.icon,
                                enabled: !_isYearChart,
                                onPressed: () {
                                  setState(() {
                                    int subD = 1;
                                    if (_seletedDay.weekday == 1) {
                                      subD = 3;
                                    } else if (_seletedDay.weekday == 7) {
                                      subD = 2;
                                    }

                                    _seletedDay = _seletedDay.subtract(
                                      Duration(days: subD),
                                    );
                                  });
                                },
                                child:
                                    const Icon(Icons.arrow_back).iconXSmall(),
                              ),
                              8.w,
                              OutlineButton(
                                density: ButtonDensity.icon,
                                enabled:
                                    !fnIsSameDay(_seletedDay, DateTime.now()),
                                onPressed: () {
                                  setState(() {
                                    int addD = 1;
                                    if (_seletedDay.weekday == 5) {
                                      addD = 3;
                                    } else if (_seletedDay.weekday == 6) {
                                      addD = 2;
                                    }

                                    _seletedDay = _seletedDay.add(
                                      Duration(days: addD),
                                    );
                                  });
                                },
                                child: const Icon(Icons.arrow_forward)
                                    .iconXSmall(),
                              ),
                            ],
                            const Spacer(),
                            Builder(builder: (context) {
                              String dStr = '';

                              if (_isYearChart) {
                                dStr = '$_selectedYear ';
                              } else {
                                final isSameDay =
                                    fnIsSameDay(DateTime.now(), _seletedDay);

                                if (_seletedDay.year != DateTime.now().year) {
                                  dStr = fnDateFormat(
                                      'E, d MMMM, yyyy', _seletedDay);
                                } else {
                                  dStr = fnDateFormat('E, d MMMM', _seletedDay);
                                }

                                if (isSameDay) {
                                  dStr =
                                      'Today, ${fnDateFormat('d MMMM', _seletedDay)}';
                                }
                              }

                              final resOfDay = rClosedPositionsOfDay.fold(
                                0.0,
                                (acc, it) => acc += it.pnLUSD,
                              );

                              return Row(
                                children: [
                                  Text(
                                    dStr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.clText,
                                    ),
                                  ),
                                  6.w,
                                  Text(
                                    _isYearChart
                                        ? '/  ${resYear == 0 ? '0' : resYear.toStringAsFixed(1)}'
                                        : '/ ${resOfDay == 0 ? '0' : resOfDay.toStringAsFixed(1)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w200,
                                      color: (_isYearChart
                                          ? resYear < 0
                                              ? AppTheme.clRed
                                              : (resYear == 0
                                                  ? AppTheme.clText02
                                                  : AppTheme.clGreen)
                                          : resOfDay < 0
                                              ? AppTheme.clRed
                                              : (resOfDay == 0
                                                  ? AppTheme.clText02
                                                  : AppTheme.clGreen)),
                                    ),
                                  ),
                                ],
                              );
                            }),
                            const Spacer(),
                            OutlineButton(
                              density: ButtonDensity.icon,
                              onPressed: () {
                                setState(() {
                                  _isYearChart = !_isYearChart;
                                });
                              },
                              child: Icon(
                                LucideIcons.chartLine,
                                color: _isYearChart
                                    ? AppTheme.clYellow
                                    : AppTheme.clText,
                              ).iconXSmall(),
                            ),
                          ],
                        ),
                      ),
                      8.h,
                      if (_isYearChart)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 15, right: 10),
                            child: ReportYearChart(
                              data: dataYear,
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: SaxoClosedPositionsReportGrid(
                            data: rClosedPositionsOfDay,
                            sortBy: [
                              ('Trade Date', 'desc'),
                            ],
                            onTap: (symbol) async {
                              final inst = instVM.instruments.firstWhereOrNull(
                                  (it) => it.symbol == symbol);
                              if (inst != null) {
                                await instVM.setInstrumentBySymbol(symbol);
                              }
                            },
                          ),
                        ),
                      6.h,
                      Container(
                        height: 25,
                        width: context.width,
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Rest: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.clText04,
                                  ),
                                ),
                                Text(
                                  tradeVM
                                      .balance.cashAvailableForTradingFormated,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Cash: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.clText04,
                                      ),
                                    ),
                                    Text(
                                      tradeVM.balance.totalValueFormated,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                10.w,
                                if (_loadingUp)
                                  SizedBox(
                                    height: 13,
                                    width: 13,
                                    child: AppProgressIndicator(),
                                  )
                                else
                                  AppMouseButton(
                                    onTap: () async {
                                      setState(() => _loadingUp = true);

                                      await appVM.reFullTradingAndChat();

                                      await reportVM.init1();
                                      await tradeVM.init1();

                                      _loadingUp = false;

                                      appVM.notify();
                                      instVM.notify();
                                      tradeVM.notify();
                                      reportVM.notify();
                                    },
                                    child: Icon(
                                      BootstrapIcons.signpostSplit,
                                      color: AppTheme.clYellow,
                                      size: 13,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            5.h,
          ],
        ),
      ),
    );
  }
}

class ReportCalendarMonth extends StatelessWidget {
  final List<SaxoClosedPositionModel> data;
  final int year;
  final int month;
  final DateTime selectedDay;
  final Function(DateTime selectedDay) onDaySelected;

  const ReportCalendarMonth({
    super.key,
    required this.data,
    required this.year,
    required this.month,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final dt = DateTime(year, month, 1);

    final dataMonth = data.where((it) {
      return it.tradeDate?.year == year && it.tradeDate?.month == month;
    }).toList();

    final resMonth = dataMonth.fold(
      0.0,
      (acc, it) => acc += it.pnLUSD,
    );

    return SizedBox(
      height: 230,
      width: 199,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                DateFormat('MMMM').format(dt),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                  color: AppTheme.clText,
                ),
              ),
              6.w,
              Text(
                '/ ${resMonth == 0 ? '0' : resMonth.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                  color: resMonth < 0
                      ? AppTheme.clRed
                      : (resMonth == 0 ? AppTheme.clText02 : AppTheme.clGreen),
                ),
              ),
            ],
          ),
          8.h,
          Stack(
            children: [
              TableCalendar(
                rowHeight: 30,
                firstDay: DateTime(dt.year, dt.month, 1),
                lastDay: DateTime(dt.year, dt.month + 1, 0),
                focusedDay: DateTime(dt.year, dt.month, 1),
                startingDayOfWeek: StartingDayOfWeek.monday,
                availableGestures: AvailableGestures.none,
                calendarStyle: CalendarStyle(isTodayHighlighted: false),
                rangeSelectionMode: RangeSelectionMode.disabled,
                headerVisible: false,
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    if (day.weekday == DateTime.saturday ||
                        day.weekday == DateTime.sunday) {
                      return Container();
                    }

                    final now = DateTime.now();
                    bool isSelected = fnIsSameDay(selectedDay, day);
                    bool isToday = fnIsSameDay(now, day);
                    bool isNotAfterToday =
                        day.isBefore(now) || fnIsSameDay(day, now);

                    Color textColor = AppTheme.clText09;
                    if (!isNotAfterToday) {
                      textColor = AppTheme.clText04;
                    }

                    //~

                    Color color = Colors.transparent;

                    final dataDay = data.where((it) {
                      return fnIsSameDay(it.tradeDate, day);
                    }).toList();

                    final resDay = dataDay.fold(
                      0.0,
                      (acc, it) => acc += it.pnLUSD,
                    );

                    if (resDay > 0) {
                      color = Colors.green.withOpacity(0.7);
                    } else if (resDay < 0) {
                      color = Colors.red.withOpacity(0.7);
                    }

                    final dayW = Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(
                          width: 1,
                          color: isSelected
                              ? AppTheme.clWhite
                              : (isToday
                                  ? AppTheme.clYellow
                                  : AppTheme.clBlack),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: 13,
                            color: textColor,
                          ),
                        ),
                      ),
                    );

                    if (isNotAfterToday) {
                      return AppMouseButton(
                        onTap: () {
                          if (isNotAfterToday) {
                            onDaySelected(day);
                          }
                        },
                        child: dayW,
                      );
                    }

                    return dayW;
                  },
                  disabledBuilder: (context, day, focusedDay) {
                    if (day.weekday == DateTime.saturday ||
                        day.weekday == DateTime.sunday) {
                      return Container();
                    }

                    return Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: AppTheme.clText01,
                          fontSize: 11,
                        ),
                      ),
                    );
                  },
                  dowBuilder: (context, day) {
                    if (day.weekday == DateTime.saturday ||
                        day.weekday == DateTime.sunday) {
                      return Container();
                    }

                    return Center(
                      child: Text(
                        DateFormat('E').format(day).substring(0, 1),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.clText03,
                        ),
                      ),
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: AppTheme.clYellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 22,
                right: 0,
                child: Column(
                  children: [
                    for (var wN in [1, 2, 3, 4, 5])
                      Builder(builder: (context) {
                        final dataWeek = dataMonth.where((it) {
                          if (it.tradeDate == null) return false;
                          return fnWeekOfMonth(it.tradeDate!) == wN;
                        }).toList();

                        final resWeek = dataWeek.fold(
                          0.0,
                          (acc, it) => acc += it.pnLUSD,
                        );

                        return SizedBox(
                          height: 30.5,
                          width: 52,
                          child: Text(
                            ' ${resWeek == 0 ? '0' : resWeek.toStringAsFixed(1)}',
                            style: TextStyle(
                              color: resWeek < 0
                                  ? AppTheme.clRed
                                  : (resWeek == 0
                                      ? AppTheme.clText02
                                      : AppTheme.clGreen),
                              fontSize: 12,
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
