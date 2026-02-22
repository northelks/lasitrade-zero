import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lasitrade/widgets/empty.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:lasitrade/models/saxo/saxo_closed_position_model.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/widgets/buttons/mouse_button.dart';
import 'package:lasitrade/theme.dart';

class SaxoClosedPositionsReportGrid extends StatefulWidget {
  final List<SaxoClosedPositionModel> data;
  final List<(String, String)> sortBy;

  final Function(String symbol) onTap;

  const SaxoClosedPositionsReportGrid({
    super.key,
    required this.data,
    required this.sortBy,
    //
    required this.onTap,
  });

  @override
  State<SaxoClosedPositionsReportGrid> createState() =>
      _SaxoClosedPositionsReportGridState();
}

class _SaxoClosedPositionsReportGridState
    extends State<SaxoClosedPositionsReportGrid> {
  late SaxoClosedPositionsReportGridSource _reportGridSource;
  late DataGridController _ctrl;

  @override
  void initState() {
    super.initState();

    _ctrl = DataGridController();

    _reportGridSource = SaxoClosedPositionsReportGridSource(
      data: widget.data,
      onTap: widget.onTap,
    );

    _refreshColumnSorting();
  }

  @override
  void didUpdateWidget(covariant SaxoClosedPositionsReportGrid oldWidget) {
    _reportGridSource.data = widget.data;

    _refreshColumnSorting();
    _reportGridSource.notifyListeners();

    super.didUpdateWidget(oldWidget);
  }

  void _refreshColumnSorting() {
    _reportGridSource.sortedColumns.clear();

    for (var srb in widget.sortBy) {
      _reportGridSource.sortedColumns.add(SortColumnDetails(
        name: srb.$1,
        sortDirection: srb.$2 == 'asc'
            ? DataGridSortDirection.ascending
            : DataGridSortDirection.descending,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return Center(child: AppEmpty());
    }

    return Container(
      width: 721,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: SfDataGridTheme(
        data: SfDataGridThemeData(
          headerColor: AppTheme.clBlack,
          sortIconColor: AppTheme.clWhite,
          gridLineColor: Colors.black,
          gridLineStrokeWidth: 2,
        ),
        child: SfDataGrid(
          source: _reportGridSource,
          navigationMode: GridNavigationMode.row,
          selectionMode: SelectionMode.none,
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          showVerticalScrollbar: true,
          isScrollbarAlwaysShown: false,
          rowHeight: 42,
          headerRowHeight: 24,
          controller: _ctrl,
          columns: <GridColumn>[
            for (var clm in [
              ('Trade Date', 'Trade Date', 75.0),
              ('Instrument', 'Instrument', 75.0),
              ('PnL USD', 'PnL USD', 75.0),
              ('PnL Pt.', 'PnL Pt.', 70.0),
              ('Amount', 'Amount', 30.0),
              ('Open Price', 'Open Price', 75.0),
              ('Close Price', 'Close Price', 70.0),
            ])
              GridColumn(
                columnName: clm.$1,
                columnWidthMode: ColumnWidthMode.fill,
                maximumWidth: double.nan,
                allowFiltering: false,
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
        ),
      ),
    );
  }
}

class SaxoClosedPositionsReportGridSource extends DataGridSource {
  List<SaxoClosedPositionModel> data;
  final Function(String symbol) onTap;

  SaxoClosedPositionsReportGridSource({
    required this.data,
    //
    required this.onTap,
  });

  @override
  List<DataGridRow> get rows {
    return data.map<DataGridRow>((SaxoClosedPositionModel data) {
      return DataGridRow(
        cells: <DataGridCell>[
          DataGridCell<String>(
            columnName: 'Trade Date',
            value: data.tradeDateClose!.toSimpleDate(),
          ),
          DataGridCell<String>(
            columnName: 'Instrument',
            value: data.symbol.toString(),
          ),
          DataGridCell<String>(
            columnName: 'PnL USD',
            value: data.pnLUSD.toString(),
          ),
          DataGridCell<String>(
            columnName: 'PnL Pt.',
            value: (data.closePrice - data.openPrice).toStringAsFixed(2),
          ),
          DataGridCell<String>(
            columnName: 'Amount',
            value: data.amount.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Open Price',
            value: data.openPrice.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Close Price',
            value: data.closePrice.toString(),
          ),
        ],
      );
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final symbol = row.getCells()[1].value as String;

    return DataGridRowAdapter(
      cells: <Widget>[
        for (var i in List.generate(7, (i) => i))
          Builder(builder: (context) {
            String value = row.getCells()[i].value.toString();
            String valueAd = '';

            final bool isTradeDate =
                row.getCells()[i].columnName == 'Trade Date';
            final bool isAmount = row.getCells()[i].columnName == 'Amount';

            if (isAmount) {
              if (value.endsWith('.0')) {
                value = value.substring(0, value.length - 2);
              }
            } else if (isTradeDate) {
              final dt = DateTime.parse(value);
              if (dt.year != DateTime.now().year) {
                valueAd = '${dt.year}';
              }

              value = DateFormat('dd MMM').format(dt);
            }

            return AppMouseButton(
              onTap: () => onTap(symbol),
              child: Container(
                color: AppTheme.clTransparent,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 2, bottom: 2),
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.clText09,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (valueAd.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.only(top: 2, bottom: 2),
                        child: Text(
                          valueAd,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.clText05,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
