import 'package:flutter/material.dart' hide Tooltip;
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' hide Colors;
import 'package:url_launcher/url_launcher.dart';

import 'package:lasitrade/utils/core_utils.dart';
import 'package:lasitrade/viewmodels/infoprice_viewmodel.dart';
import 'package:lasitrade/viewmodels/instrument_viewmodel.dart';
import 'package:lasitrade/models/db/db_news_model.dart';
import 'package:lasitrade/widgets/empty.dart';
import 'package:lasitrade/widgets/progress_indicator.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/theme.dart';
import 'package:lasitrade/widgets/buttons/mouse_button.dart';

class InstrumentScreen extends StatefulWidget {
  const InstrumentScreen({super.key});

  @override
  State<InstrumentScreen> createState() => _InstrumentScreenState();
}

class _InstrumentScreenState extends State<InstrumentScreen> {
  @override
  void didChangeDependencies() {
    context.watch<InstrumentViewModel>();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 401,
      padding: const EdgeInsets.only(
        top: 5,
        left: 5,
        right: 5,
        bottom: 8,
      ),
      margin: const EdgeInsets.only(top: 1),
      child: Stack(
        children: [
          Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      5.w,
                      Container(
                        height: 62,
                        margin: const EdgeInsets.only(left: 15, top: 3),
                        child: Column(
                          children: [
                            Container(
                              color: Colors.transparent,
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.only(right: 3),
                              child: Icon(
                                Icons.energy_savings_leaf_outlined,
                                size: 14,
                                color: instVM.currInstrument.watched
                                    ? AppTheme.clYellow
                                    : AppTheme.clRed05,
                              ),
                            ),
                            10.h,
                            Container(
                              color: Colors.transparent,
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.only(right: 3),
                              child: Icon(
                                BootstrapIcons.activity,
                                size: 14,
                                color: instVM.currInstrument.screenered
                                    ? AppTheme.clYellow
                                    : AppTheme.clRed05,
                              ),
                            ),
                            10.h,
                            AppMouseButton(
                              onTap: () async {
                                await instVM.pinInstrument(
                                  instVM.currInstrument,
                                  !instVM.currInstrument.pinned,
                                );
                              },
                              child: Container(
                                color: Colors.transparent,
                                alignment: Alignment.topCenter,
                                padding: const EdgeInsets.only(right: 3),
                                child: Icon(
                                  BootstrapIcons.pin,
                                  size: 12,
                                  color: instVM.currInstrument.pinned
                                      ? AppTheme.clYellow
                                      : AppTheme.clText03,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 34,
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.only(left: 8),
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        instVM.currSymbol,
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: AppTheme.clWhite,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                4.h,
                                SizedBox(
                                  height: 30,
                                  child: Text(
                                    instVM.currInstrument.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.clText08,
                                      height: 1.2,
                                    ),
                                    maxLines: 2,
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      40.w,
                      1.hhr(height: 50, padTB: 8, color: AppTheme.clText01),
                      Builder(builder: (context) {
                        context.watch<InfoPriceViewModel>();

                        return SizedBox(
                          width: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppMouseButton(
                                onTap: () async {
                                  await launchUrl(
                                    // Uri.parse(
                                    //   'https://stockanalysis.com/stocks/${instVM.currSymbol.toLowerCase()}/company/',
                                    // ),
                                    Uri.parse(
                                      'https://finance.yahoo.com/quote/${instVM.currSymbol}/',
                                    ),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Text(
                                    (infoPriceVM.curreInfoPrice?.lastTraded ??
                                            instVM.currMarketData?.price ??
                                            0.0)
                                        .toStringAsFixed(2),
                                    style: TextStyle(
                                      color: AppTheme.clWhite,
                                    ),
                                  ).x4Large.semiBold,
                                ),
                              ),
                              8.w,
                              SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          (infoPriceVM.curreInfoPrice?.percD ??
                                                  instVM.currMarketData
                                                      ?.pricePerc ??
                                                  0.0)
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                            color: fnGetNumColor((infoPriceVM
                                                    .curreInfoPrice?.percD ??
                                                instVM.currMarketData
                                                    ?.pricePerc ??
                                                0.0)),
                                          ),
                                        ).xSmall.semiBold,
                                        1.w,
                                        Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 6),
                                          child: Text(
                                            '%',
                                            style: TextStyle(
                                              color: fnGetNumColor((infoPriceVM
                                                      .curreInfoPrice?.percD ??
                                                  instVM.currMarketData
                                                      ?.pricePerc ??
                                                  0.0)),
                                              fontSize: 8,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    2.h,
                                    Text(
                                      (infoPriceVM.curreInfoPrice?.netD ??
                                              instVM.currMarketData?.priceNet ??
                                              0.0)
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                        color: fnGetNumColor((infoPriceVM
                                                .curreInfoPrice?.netD ??
                                            instVM.currMarketData?.priceNet ??
                                            0.0)),
                                      ),
                                    ).xSmall,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    // SizedBox(
                    //   width: 505 - 75 - 14,
                    //   child: 7.hrr(color: AppTheme.clBlack),
                    // ),
                    Expanded(child: 7.hrr(color: AppTheme.clBlack)),
                    15.w,
                    // SizedBox(
                    //   child: Text(
                    //     instVM.lastMarketDataUpdateDate?.toSimpleDateTime(
                    //           withToday: true,
                    //           withYear: true,
                    //         ) ??
                    //         'No Date',
                    //     style: TextStyle(fontSize: 10, color: Colors.white10),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              color: Colors.transparent,
                              child: Column(
                                children: [
                                  Text(
                                    'Market Cap',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppTheme.clText03,
                                    ),
                                  ),
                                  4.h,
                                  Text(fnFormatNumber(
                                          instVM.currMarketData?.marketCap ??
                                              0.0))
                                      .medium,
                                ],
                              ),
                            ),
                            8.h,
                            Column(
                              children: [
                                Text(
                                  'Volume',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.clText03,
                                  ),
                                ),
                                4.h,
                                Row(
                                  children: [
                                    Text(fnFormatNumber(
                                            instVM.currMarketData?.volume ??
                                                0.0))
                                        .medium,
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    15.hhr(height: 50, padTB: 8, color: AppTheme.clBlack),
                    Column(
                      children: [
                        Column(
                          children: [
                            Text(
                              'Shs Outstand',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.clText03,
                              ),
                            ),
                            4.h,
                            Text(fnFormatNumber(
                                    instVM.currMarketData?.shsOutstand ?? 0.0))
                                .medium,
                          ],
                        ),
                        8.h,
                        Column(
                          children: [
                            Text(
                              'Shs Float',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.clText03,
                              ),
                            ),
                            4.h,
                            Row(
                              children: [
                                Text(fnFormatNumber(
                                        instVM.currMarketData?.shsFloat ?? 0.0))
                                    .medium,
                                5.w,
                                Text('/ ${(instVM.currMarketData?.shsFloatPer ?? 0.0).toStringAsFixed(2)}')
                                    .medium,
                                1.w,
                                Container(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    '%',
                                    style: TextStyle(
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    15.hhr(height: 50, padTB: 8, color: AppTheme.clBlack),
                    Column(
                      children: [
                        Column(
                          children: [
                            Text(
                              'Short Interest',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.clText03,
                              ),
                            ),
                            4.h,
                            Row(
                              children: [
                                Text(fnFormatNumber(
                                        instVM.currMarketData?.shortInterest ??
                                            0.0))
                                    .medium,
                              ],
                            ),
                          ],
                        ),
                        8.h,
                        Column(
                          children: [
                            Text(
                              'Short Float, Ratio',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.clText03,
                              ),
                            ),
                            4.h,
                            Row(
                              children: [
                                Text((instVM.currMarketData?.shortFloat ?? 0.0)
                                        .toStringAsFixed(2))
                                    .medium,
                                1.w,
                                Container(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    '%',
                                    style: TextStyle(
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                                Text(' / ${(instVM.currMarketData?.shortRatio ?? 0.0).toStringAsFixed(2)}d')
                                    .medium,
                              ],
                            ),
                          ],
                        ),
                        5.h,
                      ],
                    ),
                  ],
                ),
              ),
              4.h,
              AppMouseButton(
                onTap: () async {
                  instVM.scrapingMarketData = true;
                  instVM.notify();

                  await instVM.scrapeDbSymbolDataWithNet();

                  instVM.scrapingMarketData = false;
                  instVM.notify();
                },
                child: Container(
                  height: 12,
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.only(right: 5),
                  child: Builder(builder: (context) {
                    return Builder(
                      builder: (context) {
                        if (instVM.currMarketData == null) return Container();

                        final mins = DateTime.now()
                            .difference(instVM.currMarketData!.timeAt)
                            .inMinutes;

                        return Text(
                          mins >= 2 ? '$mins min ago' : '. . .',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.clText04,
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              3.h,
              Container(
                height: 192,
                color: AppTheme.clText005,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 5,
                  left: 10,
                  right: 5,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (instVM.currNews.isEmpty)
                        Container(
                          width: context.width,
                          padding: const EdgeInsets.only(top: 80),
                          child: Center(child: AppEmpty()),
                        ),
                      for (var nw in instVM.currNews)
                        InstrumentNewsItem(nw: nw),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (instVM.scrapingMarketData)
            Container(
              height: 400,
              width: context.width,
              color: Colors.black54,
              child: Center(
                child: AppProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

class InstrumentNewsItem extends StatefulWidget {
  const InstrumentNewsItem({
    super.key,
    required this.nw,
  });

  final DBNewsModel nw;

  @override
  State<InstrumentNewsItem> createState() => _InstrumentNewsItemState();
}

class _InstrumentNewsItemState extends State<InstrumentNewsItem> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return AppMouseButton(
      onTap: () async {
        await launchUrl(
          Uri.parse(widget.nw.url),
          mode: LaunchMode.externalApplication,
        );
      },
      onHover: (bool value) {
        if (_isHover != value) {
          setState(() {
            _isHover = value;
          });
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.nw.timeAt.toSimpleDateTime(
                  withToday: true,
                  withYear: true,
                ),
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.clText05,
                ),
              ),
              10.w,
              Expanded(
                child: Tooltip(
                  tooltip: TooltipContainer(
                    child: Text(widget.nw.text),
                  ).call,
                  child: Text(
                    widget.nw.text,
                    style: TextStyle(
                      fontSize: 11,
                      color: _isHover ? AppTheme.clYellow08 : AppTheme.clText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          10.h,
        ],
      ),
    );
  }
}
