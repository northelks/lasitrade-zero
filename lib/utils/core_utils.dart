import 'dart:io';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:lasitrade/theme.dart';

final DotEnv appDoteEnv = DotEnv();

abstract class AppErrorCode {
  // 4xx
  static const String er404 = '404';

  static const String er701 = '701'; // cannot watch an instument
}

class AppError {
  AppError({
    this.message,
    this.code = AppErrorCode.er404,
    this.error,
    this.stack,
  });

  String? message;
  final String code;
  final dynamic error;
  final dynamic stack;

  @override
  String toString() {
    if (message == null) {
      return 'ERROR [$code]';
    }

    return 'ERROR [$code]: $message';
  }

  String toStringF() {
    return error.toString();
  }
}

class AppDebouncer {
  final Duration? delay;
  Timer? _timer;

  AppDebouncer({this.delay});

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay!, action);
  }

  void cancel() => _timer?.cancel();
}

abstract class Horizon {
  static const int m1 = 1;
  // static const int m5 = 5;
  // static const int m10 = 10;
  // static const int m15 = 15;
  // static const int m30 = 30;
  // static const int h1 = 60;
  // static const int h2 = 120;
  // static const int h4 = 240;
  // static const int h6 = 360;
  // static const int h8 = 480;
  static const int d1 = 1440;
  // static const int w1 = 10080;
  // static const int mn1 = 43200;
}

//+ utils

Future<dynamic> fnTry(
  Future<dynamic> Function() fn, {
  Duration? delay,
}) async {
  try {
    if (delay != null) {
      dynamic ffnRes;
      Future<dynamic> ffn() async {
        ffnRes = await fn();
      }

      await Future.wait([
        Future.delayed(delay),
        ffn(),
      ]);

      return ffnRes;
    } else {
      return await fn();
    }
  } catch (error, _) {
    // CrashService.recordError(error, stack: stack);
    return null;
  }
}

Future<bool> fnIsOnline() async {
  try {
    final response = await Dio().get('https://www.google.com');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (_) {
    return false;
  }
}

String fnDotEnv(String key) {
  return appDoteEnv.maybeGet(key, fallback: '')!;
}

//+ dates

String fnDateFormat(String pattern, DateTime date) {
  return DateFormat(pattern).format(date);
}

String fnTimeFormat(DateTime date) {
  return DateFormat('HH:mm').format(date);

  // if (appVM.settings.timeformat == 24) {
  //   return DateFormat('HH:mm').format(date);
  // } else {
  //   return DateFormat('hh:mm aaa').format(date);
  // }
}

int fnWeekOfMonth(DateTime date) {
  final firstDayOfMonth = DateTime(date.year, date.month, 1);
  final daysDifference = date.day + firstDayOfMonth.weekday - 1;

  return (daysDifference / 7).ceil();
}

//+ numbers

String fnFormatNumber(num value) {
  if (value >= 1000000000) {
    return '${(value / 1000000000).toStringAsFixed(2)}B';
  } else if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(2)}M';
  } else if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(2)}K';
  } else {
    return value.toString();
  }
}

double fnTryParseHumanNumber(String input) {
  input = input.trim().toUpperCase();

  final regex = RegExp(r'^([\d\.]+)([KMB]?)$');
  final match = regex.firstMatch(input);

  if (match == null) {
    return 0.0;
  }

  final value = double.parse(match.group(1)!);
  final suffix = match.group(2);

  switch (suffix) {
    case 'K':
      return value * 1e3;
    case 'M':
      return value * 1e6;
    case 'B':
      return value * 1e9;
    default:
      return value;
  }
}

//+ date

bool fnIsSameDay(dynamic date1, dynamic date2) {
  if (date2 == date1) {
    return true;
  }

  if (date1 == null || date2 == null) {
    return false;
  }

  return date1.month == date2.month &&
      date1.year == date2.year &&
      date1.day == date2.day;
}

//+ csv

Future<String> fnJsonToCsv({
  required List<Map<String, dynamic>> jsons,
  required String name,
}) async {
  final List<String> headers = jsons.first.keys.toList();

  final List<List<dynamic>> rows = [
    headers,
    ...jsons.map((map) => headers.map((h) => map[h]).toList())
  ];

  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$name.csv');

  final String csv = const ListToCsvConverter().convert(rows);
  await file.writeAsString(csv);

  return csv;
}

//+ number icons

// IconData fnGetNumIcon(int i) {
//   return switch (i) {
//     0 => BootstrapIcons.icon0Square,
//     1 => BootstrapIcons.icon1Square,
//     2 => BootstrapIcons.icon2Square,
//     3 => BootstrapIcons.icon3Square,
//     4 => BootstrapIcons.icon4Square,
//     5 => BootstrapIcons.icon5Square,
//     6 => BootstrapIcons.icon6Square,
//     7 => BootstrapIcons.icon7Square,
//     8 => BootstrapIcons.icon8Square,
//     9 => BootstrapIcons.icon9Square,
//     _ => Icons.adjust,
//   };
// }

//+ num color

Color fnGetNumColor(num? num) {
  num ??= 0;

  if (num < 0) {
    return AppTheme.clRed;
  } else if (num > 0) {
    return AppTheme.clGreen;
  }

  return AppTheme.clWhite;
}


// final percent = NumberFormat('+#,##0.00%;-#,##0.00%');
// percent.format(0.0932); // +9.32%
// percent.format(-0.041); // -4.10%