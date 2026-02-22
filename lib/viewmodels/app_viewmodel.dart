import 'package:flutter/material.dart';

import 'package:lasitrade/constants.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/logger.dart';
import 'package:lasitrade/models/saxo/saxo_exchange_model.dart';
import 'package:lasitrade/route.dart';
import 'package:lasitrade/models/saxo/saxo_account_model.dart';
import 'package:lasitrade/utils/core_utils.dart';
import 'package:lasitrade/utils/pref_utils.dart';

class AppViewModel extends ChangeNotifierExt {
  IconData tab = cstTabs['home']!;

  //~

  late SaxoAccountModel _account;
  SaxoAccountModel get account => _account;

  String get accountKey => appVM.account.accountKey;
  String get clientKey => appVM.account.clientKey;

  bool _isFullTradingAndChat = false;
  bool get isFullTradingAndChat => _isFullTradingAndChat;

  //~

  late SaxoExchangeModel _nasdaq;
  SaxoExchangeModel get nasdaq => _nasdaq;

  ExchangeSessionModel get currNasdaqSession {
    final now = DateTime.now();
    for (var ses in nasdaq.exchangeSessions) {
      if (now.isAfter(ses.startTime) && now.isBefore(ses.endTime)) {
        return ses;
      }
    }

    throw AppError(message: 'No current market session found!');
  }

  bool get isNasdaqOpen => currNasdaqSession.state == 'AutomatedTrading';
  bool get isNasdaqClose => !isNasdaqOpen;
  DateTime get whenNasdaqOpen {
    final ses = nasdaq.exchangeSessions.firstWhere(
      (e) => e.state == 'AutomatedTrading',
    );
    return ses.startTime;
  }

  bool get isNasdaqPreMarket => currNasdaqSession.state == 'PreMarket';
  DateTime get whenNasdaqPreMarket {
    final ses = nasdaq.exchangeSessions.firstWhere(
      (e) => e.state == 'PreMarket',
    );
    return ses.startTime;
  }

  //~

  late int _screenerPriceFrom;
  int get screenerPriceFrom => _screenerPriceFrom;

  late int _screenerPriceTo;
  int get screenerPriceTo => _screenerPriceTo;

  //~

  Future<void> init1() async {
    await reScreener();

    await webServ.init();

    if (await authServ.validateTokens()) {
      await psqlServ.init();

      await reFullTradingAndChat();
      if (!_isFullTradingAndChat) {
        _isFullTradingAndChat = await userServ.reqFullTradingAndChat();
      }

      _account = await userServ.getAccount();
      _nasdaq = await instServ.getExchangeNasdaq();

      await instVM.init1();
      await infoPriceVM.init1();
      await histVM.init1();
      await tradeVM.init1();

      // do it without await
      reportVM.init1(dirty: true);

      _appLoop();

      AppRoute.goTo(AppRoute.srRoot);
    }
  }

  Future<void> reFullTradingAndChat() async {
    _isFullTradingAndChat = await userServ.isFullTradingAndChat();
  }

  Future<void> reScreener() async {
    _screenerPriceFrom = (await fnPrefGetScreener())['price_from'];
    _screenerPriceTo = (await fnPrefGetScreener())['price_to'];
  }

  //~

  int? _lastMinute;
  DateTime? _lastBalance;
  Future<void> _appLoop() async {
    try {
      await tradeVM.syncMessages();
      tradeVM.notify();

      if (isNasdaqOpen) {
        final now = DateTime.now();

        await infoPriceVM.syncInfoPrices();
        await tradeVM.syncOrders();
        await tradeVM.syncPositions();

        infoPriceVM.notify();
        tradeVM.notify();

        //~

        // every 1 min
        if (_lastMinute != now.minute) {
          _lastMinute = now.minute;

          await histVM.syncInstrumentHists5Min(uic: instVM.currUic, month: 3);
          await histVM.syncInstrumentHists5MinN(month: 3);

          // every 5 min
          if (_lastBalance == null ||
              now.difference(_lastBalance!) >= const Duration(minutes: 5)) {
            _lastBalance = now;
            await tradeVM.syncBalance();
          }

          tradeVM.notify();

          await _syncToken();

          reportVM.init1(dirty: true);
        }
      }
    } catch (e) {
      dprint(e);
    }

    await Future.delayed(5000.mlsec);
    _appLoop();
  }

  DateTime? _dt;
  Future<void> _syncToken() async {
    _dt ??= await fnPrefGetAccessTokenExpired();
    if (_dt != null) {
      final mins = _dt!.difference(DateTime.now()).inMinutes;
      if (mins <= 2) {
        await authServ.refreshTokens();

        _dt = null;
      }
    }
  }
}
