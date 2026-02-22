import 'package:intl/intl.dart';

import 'package:lasitrade/getit.dart';
import 'package:lasitrade/models/saxo/saxo_aggregated_amount_model.dart';
import 'package:lasitrade/models/saxo/saxo_booking_model.dart';
import 'package:lasitrade/models/saxo/saxo_closed_position_model.dart';
import 'package:lasitrade/models/saxo/saxo_trade_model.dart';

class ReportService {
  Future<List<SaxoClosedPositionModel>> getReportClosedPositions({
    required DateTime fromDate,
    required DateTime toDate,
    bool? doNext = false,
  }) async {
    List<SaxoClosedPositionModel> result = [];

    final String fromDateStr = DateFormat('y-MM-dd').format(fromDate);
    final String toDateStr = DateFormat('y-MM-dd').format(toDate);

    final res = await dioCl.get(
      '/cs/v1/reports/closedPositions/${appVM.clientKey}/$fromDateStr/$toDateStr?AccountKey=${appVM.accountKey}',
    );

    if (res.statusCode == 200) {
      result.addAll(List<Map<String, dynamic>>.from(res.data['Data'])
          .map((it) => SaxoClosedPositionModel.fromJson(it))
          .toList());
    }

    Future<dynamic> fnNext(url) async {
      final res = await dioCl.get(url);
      if (res.statusCode == 200) {
        result.addAll(List<Map<String, dynamic>>.from(res.data['Data'])
            .map((it) => SaxoClosedPositionModel.fromJson(it))
            .toList());

        if ((res.data as Map).containsKey('__next')) {
          await Future.delayed(Duration(milliseconds: 100));
          await fnNext(res.data['__next']);
        }
      }
    }

    if ((doNext ?? false) && (res.data as Map).containsKey('__next')) {
      await Future.delayed(Duration(milliseconds: 100));
      await fnNext(res.data['__next']);
    }

    return result;
  }

  Future<List<SaxoBookingModel>> getReportBookings({
    required DateTime fromDate,
    required DateTime toDate,
    bool? doNext = false,
  }) async {
    List<SaxoBookingModel> result = [];

    final String fromDateStr = DateFormat('y-MM-dd').format(fromDate);
    final String toDateStr = DateFormat('y-MM-dd').format(toDate);

    final res = await dioCl.get(
      '/cs/v1/reports/bookings/${appVM.clientKey}?FromDate=$fromDateStr&ToDate=$toDateStr&AccountKey=${appVM.accountKey}',
    );

    if (res.statusCode == 200) {
      result.addAll(List<Map<String, dynamic>>.from(res.data['Data'])
          .map((it) => SaxoBookingModel.fromJson(it))
          .toList());
    }

    Future<dynamic> fnNext(url) async {
      final res = await dioCl.get(url);
      if (res.statusCode == 200) {
        result.addAll(List<Map<String, dynamic>>.from(res.data['Data'])
            .map((it) => SaxoBookingModel.fromJson(it))
            .toList());

        if ((res.data as Map).containsKey('__next')) {
          await Future.delayed(Duration(milliseconds: 100));
          await fnNext(res.data['__next']);
        }
      }
    }

    if ((doNext ?? false) && (res.data as Map).containsKey('__next')) {
      await Future.delayed(Duration(milliseconds: 100));
      await fnNext(res.data['__next']);
    }

    return result;
  }

  // DEPRICATED

  @Deprecated('last used v0.1.13+13')
  Future<List<SaxoTradeModel>> getReportTrades({
    required DateTime fromDate,
    required DateTime toDate,
    bool? doNext = false,
  }) async {
    List<SaxoTradeModel> result = [];

    final String fromDateStr = DateFormat('y-MM-dd').format(fromDate);
    final String toDateStr = DateFormat('y-MM-dd').format(toDate);

    final res = await dioCl.get(
      '/cs/v1/reports/trades/${appVM.clientKey}?FromDate=$fromDateStr&ToDate=$toDateStr&AccountKey=${appVM.accountKey}',
    );

    if (res.statusCode == 200) {
      result.addAll(List<Map<String, dynamic>>.from(res.data['Data'])
          .map((it) => SaxoTradeModel.fromJson(it))
          .toList());
    }

    Future<dynamic> fnNext(url) async {
      final res = await dioCl.get(url);
      if (res.statusCode == 200) {
        result.addAll(List<Map<String, dynamic>>.from(res.data['Data'])
            .map((it) => SaxoTradeModel.fromJson(it))
            .toList());

        if ((res.data as Map).containsKey('__next')) {
          await Future.delayed(Duration(milliseconds: 100));
          await fnNext(res.data['__next']);
        }
      }
    }

    if ((doNext ?? false) && (res.data as Map).containsKey('__next')) {
      await Future.delayed(Duration(milliseconds: 100));
      await fnNext(res.data['__next']);
    }

    return result;
  }

  @Deprecated('last used v0.1.13+13')
  Future<List<SaxoAggregatedAmountModel>> getReportAggregatedAmounts({
    required DateTime fromDate,
    required DateTime toDate,
    bool? doNext = false,
  }) async {
    List<SaxoAggregatedAmountModel> result = [];

    final String fromDateStr = DateFormat('y-MM-dd').format(fromDate);
    final String toDateStr = DateFormat('y-MM-dd').format(toDate);

    final res = await dioCl.get(
      '/cs/v1/reports/aggregatedAmounts/${appVM.clientKey}/$fromDateStr/$toDateStr?AccountKey=${appVM.accountKey}',
    );

    if (res.statusCode == 200) {
      result.addAll(List<Map<String, dynamic>>.from(res.data['Data'])
          .map((it) => SaxoAggregatedAmountModel.fromJson(it))
          .toList());
    }

    Future<dynamic> fnNext(url) async {
      final res = await dioCl.get(url);
      if (res.statusCode == 200) {
        result.addAll(List<Map<String, dynamic>>.from(res.data['Data'])
            .map((it) => SaxoAggregatedAmountModel.fromJson(it))
            .toList());

        if ((res.data as Map).containsKey('__next')) {
          await Future.delayed(Duration(milliseconds: 100));
          await fnNext(res.data['__next']);
        }
      }
    }

    if ((doNext ?? false) && (res.data as Map).containsKey('__next')) {
      await Future.delayed(Duration(milliseconds: 100));
      await fnNext(res.data['__next']);
    }

    return result;
  }
}
