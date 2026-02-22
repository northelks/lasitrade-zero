import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:lasitrade/theme.dart';
import 'package:lasitrade/viewmodels/instrument_viewmodel.dart';
import 'package:lasitrade/widgets/textfields/textfield.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/widgets/buttons/mouse_button.dart';
import 'package:lasitrade/shadcn.dart';
import 'package:provider/provider.dart';

class WatchlistManageScreen extends StatefulWidget {
  const WatchlistManageScreen({super.key});

  @override
  State<WatchlistManageScreen> createState() => _WatchlistManageScreenState();
}

class _WatchlistManageScreenState extends State<WatchlistManageScreen> {
  final TextEditingController _ctrl = TextEditingController();

  // final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // focusNode.onKeyEvent = (node, event) {
    //   if (event is KeyDownEvent &&
    //       event.logicalKey == LogicalKeyboardKey.escape) {
    //     print('ESC pressed inside TextField');
    //     return KeyEventResult.handled;
    //   }
    //   return KeyEventResult.ignored;
    // };
  }

  @override
  void didChangeDependencies() {
    context.watch<InstrumentViewModel>();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _ctrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          15.h,
          Text(
            'Watchlists',
            style: TextStyle(
              fontSize: 19,
              letterSpacing: 0.4,
            ),
          ),
          15.h,
          Expanded(
            child: SingleChildScrollView(
              child: ShadcnTable(
                rows: [
                  ShadcnTableRow(
                    cellTheme: ShadcnTableCellTheme(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        AppTheme.clYellow005,
                      ),
                      border: WidgetStateProperty.all<Border>(Border(
                        top: BorderSide(width: 2, color: AppTheme.clBlack),
                        bottom: BorderSide(width: 2, color: AppTheme.clBlack),
                      )),
                    ),
                    cells: [
                      ShadcnTableCell(
                        columnSpan: 9,
                        child: AppMouseButton(
                          onTap: () {
                            instVM.currWatchlist = 'On Desk';
                            instVM.notify();
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'On Desk',
                              style: TextStyle(
                                color: instVM.currWatchlist == 'On Desk'
                                    ? AppTheme.clYellow
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ShadcnTableCell(
                        columnSpan: 2,
                        child: AppMouseButton(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.centerRight,
                            child: Text(
                                '${infoPriceVM.infoPricesScreenered.length}'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ShadcnTableRow(
                    cellTheme: ShadcnTableCellTheme(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        AppTheme.clYellow005,
                      ),
                      border: WidgetStateProperty.all<Border>(Border(
                        bottom: BorderSide(width: 2, color: AppTheme.clBlack),
                      )),
                    ),
                    cells: [
                      ShadcnTableCell(
                        columnSpan: 9,
                        child: AppMouseButton(
                          onTap: () {
                            instVM.currWatchlist = 'Watched';
                            instVM.notify();
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Watched',
                              style: TextStyle(
                                color: instVM.currWatchlist == 'Watched'
                                    ? AppTheme.clYellow
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ShadcnTableCell(
                        columnSpan: 2,
                        child: AppMouseButton(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.centerRight,
                            child: Text('${infoPriceVM.infoPrices.length}'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ShadcnTableRow(
                    cellTheme: ShadcnTableCellTheme(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        AppTheme.clYellow005,
                      ),
                      // border: WidgetStateProperty.all<Border>(Border(
                      //   top: BorderSide(width: 2, color: AppTheme.clBlack),
                      //   bottom: BorderSide(width: 2, color: AppTheme.clBlack),
                      // )),
                    ),
                    cells: [
                      ShadcnTableCell(
                        columnSpan: 9,
                        child: AppMouseButton(
                          onTap: () {
                            instVM.currWatchlist = 'Pinned';
                            instVM.notify();
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Pinned',
                              style: TextStyle(
                                color: instVM.currWatchlist == 'Pinned'
                                    ? AppTheme.clYellow
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ShadcnTableCell(
                        columnSpan: 2,
                        child: AppMouseButton(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.centerRight,
                            child: Text('${instVM.instrumentsPinned.length}'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (var watchlist
                      in instVM.watchlists.where((e) => e.name != 'Pinned'))
                    ShadcnTableRow(
                      cellTheme: ShadcnTableCellTheme(
                        border: WidgetStateProperty.all<Border>(Border(
                          bottom: BorderSide(width: 1, color: AppTheme.clBlack),
                        )),
                      ),
                      cells: [
                        ShadcnTableCell(
                          columnSpan: 9,
                          child: ContextMenu(
                            items: [
                              MenuButton(
                                enabled: watchlist.count == 0,
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: watchlist.count != 0
                                        ? AppTheme.clText04
                                        : Colors.red,
                                  ),
                                ),
                                onPressed: (_) async {
                                  await instVM.deleteWatchlist(
                                    watchlistId: watchlist.watchlistId,
                                  );

                                  await instVM.reWatchlists();

                                  instVM.notify();
                                },
                              ),
                            ],
                            child: AppMouseButton(
                              onTap: () {
                                instVM.currWatchlist = watchlist.name;
                                instVM.notify();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                alignment: Alignment.centerLeft,
                                color: Colors.transparent,
                                child: Text(
                                  watchlist.name,
                                  style: TextStyle(
                                    color:
                                        instVM.currWatchlist == watchlist.name
                                            ? AppTheme.clYellow
                                            : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ShadcnTableCell(
                          columnSpan: 2,
                          child: AppMouseButton(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.centerRight,
                              child: Text('${watchlist.count}'),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const Spacer(),
          10.hrr(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    ctrl: _ctrl,
                    placeholder: 'Watchlist',
                    fontSize: 16,
                  ),
                ),
                10.w,
                AppMouseButton(
                  onTap: () async {
                    String name = _ctrl.text.trim();
                    List<String> names =
                        instVM.watchlists.map((it) => it.name).toList();
                    if (name.isNotEmpty && !names.contains(name)) {
                      await instVM.addWatchlist(name: name);
                      await instVM.reWatchlists();

                      _ctrl.text = '';

                      instVM.notify();

                      setState(() {});
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(5),
                    child: Icon(RadixIcons.plus, size: 18),
                  ),
                ),
              ],
            ),
          ),
          10.h,
        ],
      ),
    );
  }
}
