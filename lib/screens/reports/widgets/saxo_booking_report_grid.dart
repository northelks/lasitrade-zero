import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/models/saxo/saxo_booking_model.dart';
import 'package:lasitrade/widgets/empty.dart';
import 'package:lasitrade/widgets/buttons/mouse_button.dart';
import 'package:lasitrade/theme.dart';

class SaxoBookingReportGrid extends StatefulWidget {
  final List<SaxoBookingModel> data;
  final List<(String, String)> sortBy;

  final Function(String symbol) onTap;

  const SaxoBookingReportGrid({
    super.key,
    required this.data,
    required this.sortBy,
    //
    required this.onTap,
  });

  @override
  State<SaxoBookingReportGrid> createState() => _SaxoBookingReportGridState();
}

class _SaxoBookingReportGridState extends State<SaxoBookingReportGrid> {
  late SaxoBookingReportGridSource _reportGridSource;
  late DataGridController _ctrl;

  @override
  void initState() {
    super.initState();

    _ctrl = DataGridController();

    _reportGridSource = SaxoBookingReportGridSource(
      data: widget.data,
      onTap: widget.onTap,
    );

    _refreshColumnSorting();
  }

  @override
  void didUpdateWidget(covariant SaxoBookingReportGrid oldWidget) {
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
      width: 655,
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
              ('Date', 'Date', 75.0),
              ('Symbol', 'Symbol', 75.0),
              ('Amount', 'Amount', 100.0),
              ('BkAmount Type', 'BkAmount Type', 70.0),
              ('Value Date', 'Value Date', 75.0),
            ])
              GridColumn(
                columnName: clm.$1,
                columnWidthMode: ColumnWidthMode.fitByCellValue,
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

class SaxoBookingReportGridSource extends DataGridSource {
  List<SaxoBookingModel> data;
  final Function(String symbol) onTap;

  SaxoBookingReportGridSource({
    required this.data,
    //
    required this.onTap,
  });

  @override
  List<DataGridRow> get rows {
    return data.map<DataGridRow>((SaxoBookingModel data) {
      return DataGridRow(
        cells: <DataGridCell>[
          DataGridCell<String>(
            columnName: 'Date',
            value: data.date?.toSimpleDate().toString(),
          ),
          DataGridCell<String>(
            columnName: 'Symbol',
            value: data.symbol.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Amount',
            value: data.amount.toString(),
          ),
          DataGridCell<String>(
            columnName: 'BkAmount Type',
            value: data.bkAmountType.toString(),
          ),
          DataGridCell<String>(
            columnName: 'Value Date',
            value: data.valueDate?.toSimpleDate().toString(),
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
        for (var i in List.generate(5, (i) => i))
          Builder(builder: (context) {
            String value = row.getCells()[i].value.toString();
            if (value == 'null') {
              value = 'n/a';
            }

            final Widget child = Container(
              color: AppTheme.clTransparent,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 4, bottom: 2),
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.clText09,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );

            return AppMouseButton(
              onTap: () => onTap(symbol),
              child: child,
            );
          }),
      ],
    );
  }
}
