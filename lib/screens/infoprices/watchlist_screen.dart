import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:lasitrade/screens/infoprices/widgets/infoprice_grid.dart';
import 'package:lasitrade/screens/instrument/instrument_screen.dart';
import 'package:lasitrade/viewmodels/instrument_viewmodel.dart';
import 'package:lasitrade/widgets/buttons/mouse_button.dart';
import 'package:provider/provider.dart';
import 'package:lasitrade/shadcn.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/theme.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/viewmodels/infoprice_viewmodel.dart';

class WatchlistScreenExt extends StatelessWidget {
  const WatchlistScreenExt({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: context.width,
          child: InstrumentScreen(),
        ),
        Expanded(child: WatchlistScreen()),
      ],
    );
  }
}

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  void didChangeDependencies() {
    context.watch<InstrumentViewModel>();
    context.watch<InfoPriceViewModel>();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> watchlistNames =
        instVM.watchlists.map((it) => it.name).toList();

    watchlistNames.remove('Pinned');

    watchlistNames.sort((a, b) => a.compareTo(b));
    watchlistNames.insert(0, 'On Desk');
    watchlistNames.insert(1, 'Watched');
    watchlistNames.insert(2, 'Pinned');

    var dbInfoPrices = infoPriceVM.infoPricesOfWatchlist(
      instVM.currWatchlist,
    );
    if (instVM.currWatchlistLimit != 0) {
      dbInfoPrices = dbInfoPrices.take(instVM.currWatchlistLimit).toList();
    }

    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: context.height - 40 - 200,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: context.width,
              padding: const EdgeInsets.all(3),
              color: AppTheme.clBlack,
              child: FocusScope(
                canRequestFocus: false,
                child: Row(
                  children: [
                    Expanded(
                      child: Select<String>(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        itemBuilder: (context, item) {
                          return Text(item);
                        },
                        canUnselect: true,
                        onChanged: (value) async {
                          instVM.currWatchlist = value ?? 'On Desk';
                          instVM.currWatchlistLimit =
                              instVM.currWatchlist == 'On Desk' ? 50 : 0;

                          instVM.notify();
                        },
                        value: instVM.currWatchlist,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        popup: SelectPopup(
                          items: SelectItemList(
                            children: [
                              for (var name in watchlistNames)
                                Container(
                                  decoration: BoxDecoration(
                                    border: (name == 'Pinned')
                                        ? Border(
                                            bottom: BorderSide(
                                              width: 1,
                                              color: Colors.black,
                                            ),
                                          )
                                        : null,
                                  ),
                                  padding: EdgeInsets.only(
                                    bottom: name == 'Pinned' ? 7 : 0,
                                    top: watchlistNames.indexOf(name) > 2
                                        ? 7
                                        : 0,
                                  ),
                                  child: SelectItemButton(
                                    value: name,
                                    child: Text(name),
                                  ),
                                ),
                            ],
                          ),
                        ).call,
                      ),
                    ),
                    8.w,
                    AppMouseButton(
                      onTap: () {
                        instVM.currWatchlistLimit =
                            instVM.currWatchlistLimit == 0 ? 50 : 0;
                        instVM.notify();
                      },
                      child: Icon(
                        BootstrapIcons.fileBreak,
                        size: 14,
                        color: instVM.currWatchlistLimit != 0
                            ? AppTheme.clYellow
                            : null,
                      ),
                    ),
                    5.w,
                  ],
                ),
              ),
            ),
            2.h,
            Center(
              child: Container(
                padding: const EdgeInsets.only(bottom: 5, left: 35),
                child: Builder(builder: (context) {
                  context.watch<InfoPriceViewModel>();

                  final sec = infoPriceVM.latestInfoPriceSecAgo;

                  if (sec < 10) {
                    return Container();
                  }

                  String txt = '[ $sec sec ]';
                  if (sec > 60 * 60) {
                    txt = '[ offline ]';
                  } else if (sec > 60) {
                    txt = '[ ${sec ~/ 60} min ]';
                  }

                  if (appVM.isNasdaqPreMarket) {
                    txt =
                        '[ premarket ~ ${DateFormat('d MMM, HH:mm').format(appVM.whenNasdaqOpen)} ]';
                  } else if (appVM.isNasdaqClose) {
                    txt =
                        '[ market closed ~ ${DateFormat('d MMM, HH:mm').format(appVM.whenNasdaqPreMarket)} ]';
                  }

                  //! dev
                  return Container();

                  return Text(
                    txt,
                    style: TextStyle(
                      fontSize: 10,
                      color: appVM.isNasdaqPreMarket
                          ? AppTheme.clYellow
                          : Colors.deepOrange,
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: 6),
                child: InfoPriceGrid(
                  dbInfoPrices: dbInfoPrices,
                  sortBy: infoPriceVM.infoPriceSortBy,
                ),
              ),
            ),
            3.h,
          ],
        ),
      );
    });
  }
}
