import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lasitrade/utils/core_utils.dart';
import 'package:lasitrade/viewmodels/hist_viewmodel.dart';
import 'package:lasitrade/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:lasitrade/getit.dart';
import 'package:lasitrade/widgets/empty.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/widgets/buttons/mouse_button.dart';
import 'package:lasitrade/screens/infoprices/widgets/infoprice_grid_menu.dart';
import 'package:lasitrade/models/db/db_infoprice_model.dart';
import 'package:lasitrade/theme.dart';

class InfoPriceGrid extends StatefulWidget {
  final List<DBInfoPriceModel> dbInfoPrices;
  final List<(String, String)> sortBy;

  const InfoPriceGrid({
    super.key,
    required this.dbInfoPrices,
    required this.sortBy,
  });

  @override
  State<InfoPriceGrid> createState() => _InfoPriceGridState();
}

class _InfoPriceGridState extends State<InfoPriceGrid> {
  late InfoPriceGridSource _infoPriceGridSource;
  late DataGridController _ctrl;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _ctrl = DataGridController();

    _infoPriceGridSource = InfoPriceGridSource(
      dbInfoPrices: widget.dbInfoPrices,
      onTap: (String symbol) async {
        await instVM.setInstrumentBySymbol(symbol, onLoading: (status) {
          if (mounted) {
            setState(() => _loading = status);
          }
        });
      },
      onLoading: (value) {
        if (mounted) {
          setState(() {
            _loading = value;
          });
        }
      },
    );

    _refreshColumnSorting();
  }

  @override
  void didUpdateWidget(covariant InfoPriceGrid oldWidget) {
    _infoPriceGridSource.dbInfoPrices = widget.dbInfoPrices;

    _refreshColumnSorting();
    _infoPriceGridSource.notifyListeners();

    super.didUpdateWidget(oldWidget);
  }

  void _refreshColumnSorting() {
    _infoPriceGridSource.sortedColumns.clear();

    for (var srb in widget.sortBy) {
      _infoPriceGridSource.sortedColumns.add(SortColumnDetails(
        name: srb.$1,
        sortDirection: srb.$2 == 'asc'
            ? DataGridSortDirection.ascending
            : DataGridSortDirection.descending,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dbInfoPrices.isEmpty) {
      return Center(child: AppEmpty());
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: Colors.black,
              ),
            ),
          ),
          child: SfDataGridTheme(
            data: SfDataGridThemeData(
              headerColor: AppTheme.clYellow005,
              sortIconColor: AppTheme.clWhite,
              selectionColor: AppTheme.clText005,
              gridLineColor: Colors.black,
              gridLineStrokeWidth: 2,
            ),
            child: SfDataGrid(
              source: _infoPriceGridSource,
              allowExpandCollapseGroup: true,
              navigationMode: GridNavigationMode.row,
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              allowSorting: true,
              allowMultiColumnSorting: true,
              showVerticalScrollbar: true,
              isScrollbarAlwaysShown: false,
              rowHeight: 42,
              headerRowHeight: 24,
              showColumnHeaderIconOnHover: true,
              allowFiltering: true,
              controller: _ctrl,
              columns: <GridColumn>[
                for (var clm in [
                  ('symbol', 'Symbol', 170.0),
                  ('lasttraded', 'Price', 80.0),
                  ('percD', '1D', 65.0),
                  ('netM', '5m', 90.0),
                  ('relvol', 'Vol. %', 70.0),
                  ('vol', 'Vol.', 60.0),
                  ('infoPriceId', 'infoPriceId', 0.0),
                ])
                  GridColumn(
                    columnName: clm.$1,
                    columnWidthMode: ColumnWidthMode.fill,
                    minimumWidth: clm.$3,
                    maximumWidth: clm.$1 == 'infoPriceId' ? 0 : double.nan,
                    allowFiltering: clm.$1 == 'symbol',
                    filterPopupMenuOptions: FilterPopupMenuOptions(
                      filterMode: FilterMode.advancedFilter,
                      showColumnName: false,
                      canShowSortingOptions: false,
                    ),
                    label: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        clm.$2,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
              onColumnSortChanged: (newSortedColumn, oldSortedColumn) {
                if (newSortedColumn == null) return;

                infoPriceVM.infoPriceSortBy = [
                  (
                    newSortedColumn.name,
                    newSortedColumn.sortDirection ==
                            DataGridSortDirection.ascending
                        ? 'asc'
                        : 'desc',
                  )
                ];
                infoPriceVM.notify();
              },
            ),
          ),
        ),
        Builder(builder: (context) {
          context.watch<HistViewModel>();

          return Container(
            width: context.width,
            padding: EdgeInsets.only(
                top: _loading || histVM.notifLoadingInstrumentPerc != 0
                    ? 10
                    : 0),
            color: _loading || histVM.notifLoadingInstrumentPerc != 0
                ? Colors.black87.withOpacity(0.8)
                : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_loading || histVM.notifLoadingInstrumentPerc != 0)
                  AppProgressIndicator(),
                if (histVM.notifLoadingInstrumentPerc != 0) ...[
                  10.h,
                  Text(
                    '${histVM.notifLoadingInstrumentPerc} % of Saxo [${histVM.notifLoadingInstrumentHr}]',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  )
                ],
              ],
            ),
          );
        }),
      ],
    );
  }
}

class InfoPriceGridSource extends DataGridSource {
  List<DBInfoPriceModel> dbInfoPrices;
  final Function(String symbol) onTap;
  final Function(bool value) onLoading;

  InfoPriceGridSource({
    required this.dbInfoPrices,
    required this.onTap,
    required this.onLoading,
  });

  @override
  List<DataGridRow> get rows {
    return dbInfoPrices.map<DataGridRow>((DBInfoPriceModel dbInfoPrice) {
      final inst = instVM.instrumentOf(dbInfoPrice.uic);

      return DataGridRow(
        cells: <DataGridCell>[
          DataGridCell<String>(
            columnName: 'symbol',
            value: inst!.symbol,
          ),
          DataGridCell<double>(
            columnName: 'lasttraded',
            value: dbInfoPrice.lastTraded,
          ),
          DataGridCell<double>(
            columnName: 'percD',
            value: dbInfoPrice.percD,
          ),
          DataGridCell<double>(
            columnName: 'netM',
            value: dbInfoPrice.netM,
          ),
          DataGridCell<double>(
            columnName: 'relvol',
            value: dbInfoPrice.relvol,
          ),
          DataGridCell<int>(
            columnName: 'vol',
            value: dbInfoPrice.vol,
          ),
          DataGridCell<int>(
            columnName: 'infoPriceId',
            value: dbInfoPrice.infoPriceId,
          ),
        ],
      );
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final symbol = row.getCells()[0].value as String;
    final infoPriceId = row.getCells().last.value as int;

    final inst = instVM.instrumentOfSymbol(symbol)!;
    final infoPrice =
        dbInfoPrices.firstWhere((it) => it.infoPriceId == infoPriceId);

    final posit = tradeVM.positions.firstWhereOrNull(
      (it) => it.uic == inst.uic,
    );

    final isSelected = instVM.currSymbol == symbol;

    return DataGridRowAdapter(
      cells: <Widget>[
        for (var i in List.generate(7, (i) => i))
          Builder(builder: (context) {
            final bool isSymbol = row.getCells()[i].columnName == 'symbol';
            final bool isRelVol = row.getCells()[i].columnName == 'relvol';
            final bool isVol = row.getCells()[i].columnName == 'vol';
            final bool isPercD = row.getCells()[i].columnName == 'percD';
            final bool isNetM = row.getCells()[i].columnName == 'netM';
            final bool isPrice = row.getCells()[i].columnName == 'lasttraded';

            String value = row.getCells()[i].value.toString();
            if (isVol) {
              value = NumberFormat.compact().format(num.parse(value));
            } else if (isPercD) {
              value = infoPrice.percD.toStringAsFixed(2);
            } else if (isNetM) {
              if (infoPrice.netM > 1000) {
                value = NumberFormat.compact().format(infoPrice.netM);
              } else if (infoPrice.netM > 100) {
                value = infoPrice.netM.toStringAsFixed(0);
              } else {
                value = infoPrice.netM.toStringAsFixed(1);
              }
            } else if (isRelVol) {
              final relvolval = row.getCells()[i].value as num;
              if (relvolval > 1000) {
                value = NumberFormat.compact().format(num.parse(value));
              } else if (relvolval > 100) {
                value = relvolval.toStringAsFixed(0);
              } else {
                value = relvolval.toStringAsFixed(1);
              }
            } else if (isPrice) {
              value = (row.getCells()[i].value as num).toStringAsFixed(2);
            }

            return AppMouseButton(
              onTap: () => onTap(symbol),
              child: InfoPriceGridMenu(
                onLoading: onLoading,
                instrument: inst,
                child: Container(
                  color: isSelected
                      ? AppTheme.clYellowSelected
                      : AppTheme.clTransparent,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: isSymbol ? 2 : 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: (isPercD || isNetM || isRelVol)
                                  ? Row(
                                      children: [
                                        Text(
                                          isNetM
                                              ? '${value.substring(0, value.length - 1)}'
                                              : value,
                                          style: TextStyle(
                                            fontSize:
                                                isSymbol || isNetM ? 14 : 13,
                                            color: isPercD || isNetM
                                                ? (value.startsWith('-')
                                                    ? AppTheme.clRed
                                                    : (value == '0.0'
                                                        ? AppTheme.clWhite
                                                        : AppTheme.clGreen))
                                                : AppTheme.clWhite,
                                            fontWeight: isPrice
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        1.w,
                                        Container(
                                          padding: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          child: Text(
                                            isNetM
                                                ? '${value.substring(value.length - 1, value.length).toLowerCase()}'
                                                : '%',
                                            style: TextStyle(
                                              fontSize: isNetM ? 8 : 7,
                                              color: isPercD || isNetM
                                                  ? (value.startsWith('-')
                                                      ? AppTheme.clRed
                                                      : (value == '0.0'
                                                          ? AppTheme.clWhite
                                                          : AppTheme.clGreen))
                                                  : AppTheme.clWhite,
                                              // fontFamily: AppTheme.ffLight,
                                              fontWeight: isPrice
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : (isVol
                                      ? Builder(builder: (context) {
                                          String vt = value;
                                          String lt = '';

                                          if (value.endsWith('M')) {
                                            vt = vt.replaceAll('M', '');
                                            lt = 'M';
                                          } else if (value.endsWith('K')) {
                                            vt = vt.replaceAll('K', '');
                                            lt = 'K';
                                          }

                                          return Row(
                                            children: [
                                              Text(
                                                vt,
                                                style: TextStyle(
                                                  fontSize: isSymbol ? 14 : 13,
                                                  color: isPercD || isNetM
                                                      ? AppTheme.clGreen
                                                      : AppTheme.clWhite,
                                                  // fontFamily: AppTheme.ffLight,
                                                  fontWeight: isPrice
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              1.w,
                                              Container(
                                                padding: const EdgeInsets.only(
                                                  bottom: 8,
                                                ),
                                                child: Text(
                                                  lt,
                                                  style: TextStyle(
                                                    fontSize: 7,
                                                    color: isPercD || isNetM
                                                        ? AppTheme.clGreen
                                                        : AppTheme.clWhite,
                                                    fontWeight: isPrice
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        })
                                      : Builder(builder: (context) {
                                          return RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: value,
                                                  style: TextStyle(
                                                    fontSize:
                                                        isSymbol ? 14 : 13,
                                                    color: isPercD || isNetM
                                                        ? AppTheme.clGreen
                                                        : AppTheme.clWhite,
                                                    fontWeight: isPrice
                                                        ? FontWeight.normal
                                                        : FontWeight.normal,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        })),
                            ),
                            if (isSymbol && inst.watched && posit != null)
                              Icon(
                                Icons.local_library_outlined,
                                size: 12,
                                color: fnGetNumColor(
                                  posit.profitLossOnTrade +
                                      posit.tradeCostsTotal,
                                ),
                              ),
                            if (isSymbol && !inst.watched)
                              Icon(
                                Icons.energy_savings_leaf_outlined,
                                size: 15,
                                color: AppTheme.clRed05,
                              ),
                          ],
                        ),
                      ),
                      if (isSymbol)
                        Container(
                          padding: const EdgeInsets.only(top: 4, bottom: 2),
                          child: Text(
                            inst.name,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.clWhite.withOpacity(0.6),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (isPercD || isNetM)
                        Builder(builder: (context) {
                          String val = '';

                          if (isPercD) {
                            val = infoPrice.netD.toStringAsFixed(2);
                          } else if (isNetM) {
                            val = infoPrice.percM.toStringAsFixed(2);
                            val += '%';
                            // val = NumberFormat.compact().format(infoPrice.netM);
                          }

                          return Container(
                            padding: const EdgeInsets.only(top: 3, bottom: 2),
                            child: Text(
                              val,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: (val.startsWith('-')
                                    ? AppTheme.clRed
                                    : AppTheme.clGreen),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}
