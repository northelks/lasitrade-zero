import 'dart:async';

import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lasitrade/constants.dart';

import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/shadcn.dart';
import 'package:lasitrade/theme.dart';
import 'package:lasitrade/utils/pref_utils.dart';
import 'package:lasitrade/widgets/buttons/mouse_button.dart';
import 'package:lasitrade/widgets/progress_indicator.dart';
import 'package:lasitrade/widgets/textfields/textfield.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' show TextExtension;
import 'package:yaml/yaml.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _ctrlScreenerFrom;
  late final TextEditingController _ctrlScreenerTo;

  YamlMap? _yaml;

  bool _loading = false;
  double? _percent;

  @override
  void initState() {
    super.initState();

    _ctrlScreenerFrom = TextEditingController(
      text: appVM.screenerPriceFrom.toString(),
    );

    _ctrlScreenerTo = TextEditingController(
      text: appVM.screenerPriceTo.toString(),
    );

    scheduleMicrotask(() async {
      _yaml = loadYaml(await rootBundle.loadString('pubspec.yaml'));
      setState(() {});
    });
  }

  @override
  void dispose() {
    _ctrlScreenerFrom.dispose();
    _ctrlScreenerTo.dispose();

    super.dispose();
  }

  Future<void> _updateScreener() async {
    await fnPrefSaveScreener({
      'price_from':
          int.tryParse(_ctrlScreenerFrom.text) ?? cstScreenerPriceFrom,
      'price_to': int.tryParse(_ctrlScreenerTo.text) ?? cstScreenerPriceTo,
    });

    await appVM.reScreener();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              10.h,
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 19,
                  letterSpacing: 0.4,
                ),
              ),
              10.hrr(padLR: 20),
              5.h,
              SizedBox(
                width: context.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Tabs(
                        index: _loading
                            ? -1
                            : appVM.isFullTradingAndChat
                                ? 0
                                : 1,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 4,
                        ),
                        children: const [
                          TabItem(child: Text('FullTradingAndChat')),
                          TabItem(child: Text('OrdersOnly')),
                        ],
                        onChanged: (int value) async {
                          if (value == 0 && appVM.isFullTradingAndChat) {
                            return;
                          }

                          if (value == 1 && !appVM.isFullTradingAndChat) {
                            return;
                          }

                          setState(() => _loading = true);

                          if (value == 0) {
                            await userServ.reqFullTradingAndChat();
                          } else if (value == 1) {
                            await userServ.reqOrdersOnly();
                          }

                          await appVM.reFullTradingAndChat();
                          appVM.notify();

                          setState(() => _loading = false);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              20.h,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    for (var ses in appVM.nasdaq.exchangeSessions)
                      Builder(builder: (context) {
                        String state = ses.state;
                        if (state == 'AutomatedTrading') {
                          state = 'Open';
                        }

                        Color clr = AppTheme.clText;
                        bool isCurrent = false;
                        // if (state == 'Open') {
                        //   clr = AppTheme.clGreen;
                        // }

                        if (DateTime.now().isAfter(ses.startTime) &&
                            DateTime.now().isBefore(ses.endTime)) {
                          // clr = AppTheme.clYellow;
                          isCurrent = true;
                        }

                        final df = DateFormat('dd MMM HH:mm');

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          ),
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: isCurrent
                                  ? AppTheme.clYellow.withOpacity(0.5)
                                  : Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.clText,
                                ),
                              ),
                              SizedBox(
                                width: context.width * 0.1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      df.format(ses.startTime),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: clr,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      ' - ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: clr,
                                        fontWeight: state == 'Open'
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      df.format(ses.endTime),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: clr,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    15.hrr(),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            10.w,
                            Text('Screener'),
                            AppMouseButton(
                              onTap: () async {
                                setState(() {
                                  _loading = true;
                                });

                                for (var inst in instVM.instrumentsWatched) {
                                  int inx =
                                      instVM.instrumentsWatched.indexOf(inst);
                                  setState(() {
                                    _percent = inx *
                                        100 /
                                        instVM.instrumentsWatched.length;
                                  });

                                  try {
                                    await histVM.syncInstrumentHists1Day(
                                      uic: inst.uic,
                                    );

                                    await histVM.syncInstrumentHists5Min(
                                      uic: inst.uic,
                                      month: 3,
                                    );
                                  } catch (e) {
                                    await Future.delayed(1500.mlsec);
                                  }

                                  await Future.delayed(500.mlsec);
                                }

                                setState(() {
                                  _loading = false;
                                  _percent = null;
                                });
                              },
                              child: Icon(
                                BootstrapIcons.balloon,
                                color: AppTheme.clYellow,
                                size: 14,
                              ),
                            )
                          ],
                        ),
                        8.h,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100,
                              margin: const EdgeInsets.only(left: 25),
                              child: AppTextField(
                                title: 'Price From',
                                ctrl: _ctrlScreenerFrom,
                                fontSize: 16,
                                onFocusLost: _updateScreener,
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: AppTextField(
                                title: 'Price To',
                                ctrl: _ctrlScreenerTo,
                                fontSize: 16,
                                onFocusLost: _updateScreener,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (_yaml != null)
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${_yaml!['version0']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.clText03,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ).mono,
                          2.h,
                          Text(
                            '${_yaml!['date0']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.clText03,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ).mono,
                        ],
                      ),
                      Text(
                        '...',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.clText03,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ).mono,
                      Column(
                        children: [
                          Text(
                            '${_yaml!['version']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.clText07,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ).mono,
                          2.h,
                          Text(
                            '${_yaml!['date']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.clText07,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ).mono,
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (_loading)
          AppProgressIndicatorCenter(
            percent: _percent,
          ),
      ],
    );
  }
}
