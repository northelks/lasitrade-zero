import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(
    colors: false,
    printEmojis: false,
    methodCount: 5,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);

void dprint(Object? msg) {
  if (kDebugMode) {
    print(msg);
  }
}
