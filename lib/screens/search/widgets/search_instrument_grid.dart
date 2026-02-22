import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:lasitrade/screens/infoprices/widgets/infoprice_grid_menu.dart';
import 'package:lasitrade/widgets/empty.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/models/db/db_instrument_model.dart';
import 'package:lasitrade/widgets/buttons/mouse_button.dart';
import 'package:lasitrade/theme.dart';

class SearchInstrumentGrid extends StatefulWidget {
  final List<DBInstrumentModel> instruments;
  final Function(DBInstrumentModel instrument) onTap;

  const SearchInstrumentGrid({
    super.key,
    required this.instruments,
    required this.onTap,
  });

  @override
  State<SearchInstrumentGrid> createState() => _SearchInstrumentGridState();
}

class _SearchInstrumentGridState extends State<SearchInstrumentGrid> {
  late DataGridController _ctrl;

  late SearchInstrumentGridSource _searchInstrumentGridSource;
  late SearchInstrumentGridSelectionManager _searchInstrumentSelectionManager;

  int _selectedInx = 0;
  int get selectedInx => _selectedInx;

  @override
  void initState() {
    super.initState();

    _ctrl = DataGridController();

    _searchInstrumentGridSource = SearchInstrumentGridSource(
      instruments: widget.instruments,
      onTap: widget.onTap,
    );

    _searchInstrumentSelectionManager = SearchInstrumentGridSelectionManager(
      onEnter: () {
        if (widget.instruments.isNotEmpty) {
          final inst = widget.instruments[_selectedInx];
          widget.onTap(inst);
        }
      },
    );

    _searchInstrumentSelectionManager.addListener(() {
      _selectedInx = _ctrl.selectedIndex;
    });
  }

  @override
  void didUpdateWidget(covariant SearchInstrumentGrid oldWidget) {
    _searchInstrumentGridSource.instruments = widget.instruments;
    _searchInstrumentGridSource.notifyListeners();

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.instruments.isEmpty) {
      return Center(child: AppEmpty());
    }

    return SfDataGridTheme(
      data: SfDataGridThemeData(
        selectionColor: AppTheme.clText005,
        gridLineColor: Colors.black,
        gridLineStrokeWidth: 2,
      ),
      child: SfDataGrid(
        source: _searchInstrumentGridSource,
        allowExpandCollapseGroup: true,
        navigationMode: GridNavigationMode.row,
        autoExpandGroups: false,
        selectionMode: SelectionMode.single,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        allowSorting: false,
        allowMultiColumnSorting: false,
        showSortNumbers: false,
        showVerticalScrollbar: true,
        isScrollbarAlwaysShown: false,
        rowHeight: 42,
        headerRowHeight: 24,
        showColumnHeaderIconOnHover: false,
        allowFiltering: false,
        controller: _ctrl,
        selectionManager: _searchInstrumentSelectionManager,
        columns: <GridColumn>[
          for (var clm in [
            ('watch', 'W.', 30.0),
            ('symbol', 'Symbol', 130.0),
            ('name', 'Name', 210.0),
          ])
            GridColumn(
              columnName: clm.$1,
              columnWidthMode: clm.$1 == 'watch'
                  ? ColumnWidthMode.auto
                  : ColumnWidthMode.lastColumnFill,
              maximumWidth: clm.$1 == 'watch' ? clm.$3 : double.nan,
              label: Container(),
            ),
        ],
      ),
    );
  }
}

class SearchInstrumentGridSource extends DataGridSource {
  List<DBInstrumentModel> instruments;
  final Function(DBInstrumentModel instrument) onTap;

  SearchInstrumentGridSource({
    required this.instruments,
    required this.onTap,
  });

  @override
  List<DataGridRow> get rows {
    return instruments.map<DataGridRow>((DBInstrumentModel instrument) {
      return DataGridRow(
        cells: <DataGridCell>[
          DataGridCell<int>(
            columnName: 'watch',
            value: instrument.watched ? 1 : 0,
          ),
          DataGridCell<String>(
            columnName: 'symbol',
            value: instrument.symbol,
          ),
          DataGridCell<String>(
            columnName: 'name',
            value: instrument.name,
          ),
        ],
      );
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final symbol = row.getCells()[1].value as String;
    final inst = instVM.instrumentOfSymbol(symbol);

    final isSelected = instVM.currSymbol == symbol;

    // print('--');
    // print(appVM.selectedInst?.symbol);
    // print('-');
    // print(symbol);

    return DataGridRowAdapter(
      cells: <Widget>[
        for (var i in List.generate(3, (i) => i))
          Builder(builder: (context) {
            dynamic value = row.getCells()[i].value;

            final bool isWatch = row.getCells()[i].columnName == 'watch';
            final bool isSymbol = row.getCells()[i].columnName == 'symbol';
            // final bool isName = row.getCells()[i].columnName == 'name';

            Widget rowW = AppMouseButton(
              onTap: () {
                final inst = instVM.instrumentOfSymbol(symbol);
                if (inst != null) {
                  onTap(inst);
                }
              },
              child: InfoPriceGridMenu(
                onLoading: (value) {
                  searchVM.loading = value;
                  searchVM.notify();
                },
                instrument: inst!,
                child: Container(
                  color: isSelected
                      ? AppTheme.clYellowSelected
                      : AppTheme.clTransparent,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      fontSize: isSymbol ? 15 : 13,
                      color: isSymbol ? AppTheme.clWhite : AppTheme.clText05,
                      fontWeight: FontWeight.normal,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            );

            if (isWatch) {
              rowW = Container(
                color: isSelected
                    ? AppTheme.clYellowSelected
                    : AppTheme.clTransparent,
                alignment: Alignment.center,
                child: Icon(
                  Icons.energy_savings_leaf_outlined,
                  size: 15,
                  color: (inst.watched) ? AppTheme.clYellow : AppTheme.clRed05,
                ),
              );
            }

            return rowW;
          }),
      ],
    );
  }
}

class SearchInstrumentGridSelectionManager extends RowSelectionManager {
  final VoidCallback onEnter;

  SearchInstrumentGridSelectionManager({
    required this.onEnter,
  });

  @override
  Future<void> handleKeyEvent(KeyEvent keyEvent) async {
    if (keyEvent.logicalKey == LogicalKeyboardKey.enter) {
      onEnter();

      return;
    }

    super.handleKeyEvent(keyEvent);
  }
}
