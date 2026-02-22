import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lasitrade/route.dart';
import 'package:lasitrade/shadcn.dart';
import 'package:lasitrade/viewmodels/search_viewmodel.dart';
import 'package:provider/provider.dart';

import 'package:lasitrade/models/db/db_instrument_model.dart';
import 'package:lasitrade/widgets/progress_indicator.dart';
import 'package:lasitrade/theme.dart';
import 'package:lasitrade/widgets/buttons/mouse_button.dart';
import 'package:lasitrade/screens/search/widgets/search_instrument_grid.dart';
import 'package:lasitrade/widgets/textfields/textfield.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/getit.dart';

class SearchPopup extends StatefulWidget {
  const SearchPopup({super.key});

  @override
  State<SearchPopup> createState() => _SearchPopupState();
}

class _SearchPopupState extends State<SearchPopup> {
  final TextEditingController _ctrl = TextEditingController();

  int _fSort = 0;

  @override
  void initState() {
    scheduleMicrotask(() {
      searchVM.searchFocusNode.requestFocus();
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    context.watch<SearchViewModel>();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    searchVM.searchFocusNode.unfocus();

    _ctrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<DBInstrumentModel> instruments = instVM.instruments;

    final query = _ctrl.text.trim();

    if (query.isNotEmpty) {
      instruments = instruments.where((it) {
        return it.symbol.toLowerCase().contains(query.toLowerCase()) ||
            it.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      if (searchVM.searchTab == 0) {
        instruments = instVM.instrumentsHistory;
      }
    }

    if (searchVM.searchTab == 1) {
      if (searchVM.fWatch == 1) {
        instruments = instruments.where((it) => it.watched).toList();

        if (searchVM.fScreen == 1) {
          instruments = instruments.where((it) => it.screenered).toList();
        } else if (searchVM.fWatch == 0) {
          instruments = instruments.where((it) => !it.screenered).toList();
        }
      } else if (searchVM.fWatch == -1) {
        instruments = instruments.where((it) => !it.watched).toList();
      }
    }

    if (_fSort == 1) {
      instruments.sort((a, b) => a.symbol.compareTo(b.symbol));
    } else {
      if (searchVM.searchTab == 1) {
        instruments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    }

    return Container(
      width: context.width / 6,
      height: context.height * 0.5,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: AppTheme.clBackground,
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 35),
            child: SearchInstrumentGrid(
              instruments: instruments,
              onTap: (instrument) async {
                searchVM.loading = true;
                searchVM.notify();

                await instVM.setInstrumentBySymbol(instrument.symbol);

                searchVM.loading = false;
                searchVM.notify();

                try {
                  _ctrl.text = '';
                } catch (_) {}

                AppRoute.goPopupBack();
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: context.width / 6,
              decoration: BoxDecoration(
                color: AppTheme.clBlack,
                border: Border(
                  bottom: BorderSide(
                    width: 2,
                    // color: Colors.deepOrange.withOpacity(0.8),
                    color: Colors.black,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      ctrl: _ctrl,
                      focusNode: searchVM.searchFocusNode,
                      autofocus: true,
                      inputFormatters: [AppTextFieldUpperCaseTextFormatter()],
                      placeholder:
                          searchVM.searchTab == 0 ? 'Search' : 'Instrument',
                      fontSize: 16,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  10.w,
                  0.hhr(height: 10),
                  12.w,
                  if (searchVM.searchTab == 1)
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: AppMouseButton(
                        onTap: () {
                          setState(() {
                            if (searchVM.fWatch == 0) {
                              searchVM.fWatch = 1;
                            } else if (searchVM.fWatch == 1) {
                              searchVM.fWatch = -1;
                            } else if (searchVM.fWatch == -1) {
                              searchVM.fWatch = 0;
                            }
                          });
                        },
                        child: Builder(builder: (context) {
                          var icon = Icons.energy_savings_leaf_outlined;
                          var color = AppTheme.clText09;

                          if (searchVM.fWatch == 0) {
                            color = AppTheme.clText03;
                          } else if (searchVM.fWatch == -1) {
                            color = AppTheme.clRed05;
                          } else if (searchVM.fWatch == 1) {
                            color = AppTheme.clYellow;
                          }

                          return Icon(icon, color: color, size: 19);
                        }),
                      ),
                    ),
                  if (searchVM.searchTab == 1) ...[
                    AppMouseButton(
                      onTap: () {
                        setState(() {
                          if (searchVM.fScreen == 0) {
                            searchVM.fScreen = 1;
                            searchVM.fWatch = 1;
                          } else if (searchVM.fScreen == 1) {
                            searchVM.fScreen = 0;
                          }
                        });
                      },
                      child: Icon(
                        BootstrapIcons.activity,
                        size: 17,
                        color: searchVM.fScreen == 1
                            ? AppTheme.clYellow
                            : AppTheme.clText03,
                      ),
                    ),
                    10.w,
                  ],
                  AppMouseButton(
                    onTap: () {
                      setState(() {
                        if (_fSort == 0) {
                          _fSort = 1;
                        } else if (_fSort == 1) {
                          _fSort = 0;
                        }
                      });
                    },
                    child: Icon(
                      Icons.sort_by_alpha_rounded,
                      color:
                          _fSort == 0 ? AppTheme.clText03 : AppTheme.clYellow,
                      size: 20,
                    ),
                  ),
                  20.w,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: context.width / 6,
              height: 35,
              decoration: BoxDecoration(
                color: AppTheme.clBlack,
                // border: Border(
                //   top: BorderSide(
                //     width: 2,
                //     // color: Colors.deepOrange.withOpacity(0.8),
                //     color: Colors.black,
                //   ),
                // ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: AppMouseButton(
                        onTap: () {
                          if (searchVM.searchTab != 0) {
                            setState(() {
                              searchVM.searchTab = 0;
                              _ctrl.text = '';
                            });
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 50,
                                child: Text(
                                  'Search',
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.4,
                                    color: searchVM.searchTab == 0
                                        ? AppTheme.clText
                                        : AppTheme.clText04,
                                  ),
                                ),
                              ),
                              Container(
                                width: 22,
                                margin: const EdgeInsets.only(
                                  bottom: 8,
                                  left: 0,
                                ),
                                child: Text(
                                  '${searchVM.searchTab == 0 ? instruments.length : instVM.instrumentsHistory.length}',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: searchVM.searchTab == 0
                                        ? AppTheme.clText
                                        : AppTheme.clText04,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    1.hhr(color: AppTheme.clText03, height: 15),
                    Expanded(
                      child: AppMouseButton(
                        onTap: () {
                          if (searchVM.searchTab != 1) {
                            setState(() {
                              searchVM.searchTab = 1;
                              _ctrl.text = '';
                            });
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 83,
                                child: Text(
                                  'Instruments',
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.4,
                                    color: searchVM.searchTab == 1
                                        ? AppTheme.clText
                                        : AppTheme.clText04,
                                  ),
                                ),
                              ),
                              Container(
                                width: 22,
                                margin: const EdgeInsets.only(
                                  bottom: 8,
                                  left: 1,
                                ),
                                child: Text(
                                  '${searchVM.searchTab == 1 ? instruments.length : instVM.instruments.length}',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: searchVM.searchTab == 1
                                        ? AppTheme.clText
                                        : AppTheme.clText04,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (searchVM.loading)
            Container(
              color: AppTheme.clBlack.withOpacity(0.5),
              child: Center(
                child: AppProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
