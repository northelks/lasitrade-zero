import 'package:flutter/material.dart' as m;
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class CrashService {
  Future<void> runApp({
    required m.Widget app,
    required String sentryDSN,
  }) async {
    await SentryFlutter.init(
      (options) {
        options.dsn = sentryDSN;
        options.tracesSampleRate = 1.0;
        options.profilesSampleRate = 1.0;
        options.enableLogs = true;

        if (kDebugMode) {
          options.beforeSend = (event, hint) {
            return null;
          };
        }
      },
      appRunner: () => m.runApp(app),
    );
  }

  Future<void> init() async {
    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      recordError(errorDetails.exception, stack: errorDetails.stack);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      recordError(error, stack: stack);
      return true;
    };
  }

  Future<void> recordError(
    dynamic error, {
    StackTrace? stack,
  }) async {}
}
