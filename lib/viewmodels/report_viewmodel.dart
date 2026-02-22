import 'package:flutter/material.dart';

import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/models/saxo/saxo_closed_position_model.dart';
import 'package:lasitrade/models/saxo/saxo_booking_model.dart';

class ReportViewModel extends ChangeNotifierExt {
  int reportTab = 0;

  List<SaxoClosedPositionModel> rClosedPositions = [];
  List<SaxoBookingModel> rSaxoBookingModel = [];

  FocusNode reportInstFocusNode = FocusNode();

  // INIT

  Future<void> init1({bool dirty = false}) async {
    await syncSaxoReportClosedPositions();
    await syncSaxoReportBookings();

    if (dirty) notify();
  }

  //+ reports

  Future<void> syncSaxoReportClosedPositions({
    DateTime? fromDate,
  }) async {
    rClosedPositions = _generateFakeClosedPositions2025();
  }

  List<SaxoClosedPositionModel> _generateFakeClosedPositions2025() {
    const instruments = [
      ('AAPL:xnas', 'Apple Inc.', 'USD', 'NASDAQ'),
      ('MSFT:xnas', 'Microsoft Corp.', 'USD', 'NASDAQ'),
      ('GOOGL:xnas', 'Alphabet Inc.', 'USD', 'NASDAQ'),
      ('AMZN:xnas', 'Amazon.com Inc.', 'USD', 'NASDAQ'),
      ('TSLA:xnas', 'Tesla Inc.', 'USD', 'NASDAQ'),
      ('NVDA:xnas', 'NVIDIA Corp.', 'USD', 'NASDAQ'),
      ('META:xnas', 'Meta Platforms Inc.', 'USD', 'NASDAQ'),
      ('JPM:xnys', 'JPMorgan Chase & Co.', 'USD', 'NYSE'),
      ('V:xnys', 'Visa Inc.', 'USD', 'NYSE'),
      ('UNH:xnys', 'UnitedHealth Group', 'USD', 'NYSE'),
      ('AMD:xnas', 'Advanced Micro Devices', 'USD', 'NASDAQ'),
      ('NFLX:xnas', 'Netflix Inc.', 'USD', 'NASDAQ'),
    ];

    // Base open prices per instrument (realistic 2025 ranges)
    const basePrices = [
      195.0, 410.0, 160.0, 195.0, 250.0, 520.0,
      540.0, 215.0, 285.0, 510.0, 165.0, 680.0,
    ];

    // Days available per month (avoiding weekends naively via offset)
    const daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    const totalTrades = 500;
    final result = <SaxoClosedPositionModel>[];

    for (var i = 0; i < totalTrades; i++) {
      // Spread trades across months proportionally
      final month = (i * 12 ~/ totalTrades) + 1;
      final maxDay = daysInMonth[month - 1];

      // Deterministic but varied day within month
      final openDay = ((i * 7 + month * 3) % (maxDay - 4)) + 1;
      final closeDay = openDay + (i % 3) + 1; // 1-3 days later

      final instIdx = i % instruments.length;
      final inst = instruments[instIdx];
      final symbol = inst.$1;
      final description = inst.$2;
      final currency = inst.$3;
      final exchange = inst.$4;

      // Open price: base ± small variance driven by i
      final basePrice = basePrices[instIdx];
      final variance = ((i * 13 + month * 7) % 41) - 20; // -20..+20
      final openPrice = double.parse(
        (basePrice + variance * 0.5).toStringAsFixed(2),
      );

      // ~75% winning trades, ~25% losing
      final isWinner = (i % 4) != 3;
      final pctMove = ((i * 3 + month) % 8 + 1) * 0.005; // 0.5%–4%
      final closePrice = double.parse(
        (openPrice * (isWinner ? 1 + pctMove : 1 - pctMove))
            .toStringAsFixed(2),
      );

      final amount = ((i % 10) + 1) * 2.0; // 2–20 shares
      final pnl = double.parse(
        ((closePrice - openPrice) * amount).toStringAsFixed(2),
      );

      final openDate = DateTime(2025, month, openDay);
      final closeDate = DateTime(2025, month, closeDay);

      final json = <String, dynamic>{
        'AccountCurrency': 'USD',
        'AccountCurrencyDecimals': 2,
        'AccountId': 'DEMO123',
        'Amount': amount,
        'AmountClose': amount,
        'AmountOpen': amount,
        'AssetType': 'Stock',
        'ClientCurrency': 'USD',
        'ClosePositionId': '${20250000 + i * 2 + 1}',
        'ClosePrice': closePrice,
        'CloseType': 'ClosePosition',
        'ExchangeDescription': exchange,
        'InstrumentCurrency': currency,
        'InstrumentDescription': description,
        'InstrumentSymbol': symbol,
        'OpenPositionId': '${20250000 + i * 2}',
        'OpenPrice': openPrice,
        'PnLAccountCurrency': pnl,
        'PnLClientCurrency': pnl,
        'PnLUSD': pnl,
        'TotalBookedOnClosingLegAccountCurrency': closePrice * amount,
        'TotalBookedOnClosingLegClientCurrency': closePrice * amount,
        'TotalBookedOnClosingLegUSD': closePrice * amount,
        'TotalBookedOnOpeningLegAccountCurrency': openPrice * amount,
        'TotalBookedOnOpeningLegClientCurrency': openPrice * amount,
        'TotalBookedOnOpeningLegUSD': openPrice * amount,
        'TradeDate': closeDate.toIso8601String(),
        'TradeDateClose': closeDate.toIso8601String(),
        'TradeDateOpen': openDate.toIso8601String(),
        'UnderlyingInstrumentDescription': description,
        'UnderlyingInstrumentSymbol': symbol,
      };

      result.add(SaxoClosedPositionModel.fromJson(json));
    }

    return result;
  }

  Future<void> syncSaxoReportBookings({
    DateTime? fromDate,
  }) async {
    fromDate ??= DateTime(1990, 1, 1);

    rSaxoBookingModel = await reportServ.getReportBookings(
      fromDate: fromDate,
      toDate: DateTime.now(),
      doNext: true,
    );
  }
}
