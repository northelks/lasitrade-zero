import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/route.dart';
import 'package:lasitrade/theme.dart';
import 'package:lasitrade/window.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:lasitrade/getit.dart';
import 'package:lasitrade/utils/core_utils.dart';
import 'package:lasitrade/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final WebViewController _ctrl;
  late final Uri _uri;

  @override
  void initState() {
    scheduleMicrotask(setupWinLogin);

    _uri = Uri.parse(
      '$cstApiAuthUrl?response_type=code&client_id=${fnDotEnv('CLIENT_ID')}&redirect_uri=http://localhost:1337/',
    );
    _ctrl = WebViewController()
      ..clearCache()
      ..clearLocalStorage()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) async {
          final code = await authServ.parseUrlCode(request.url);
          if (code != null) {
            final isOk = await authServ.fetchTokens(code);
            if (isOk) {
              AppRoute.goTo(AppRoute.srSplash);

              return NavigationDecision.prevent;
            }
          }

          return NavigationDecision.navigate;
        },
        onWebResourceError: (error) {
          // print(error.description);
        },
        onUrlChange: (change) {
          // print(change.url);
        },
        onPageFinished: (url) async {
          // print(url);
        },
        onProgress: (progress) {
          // print(progress);
        },
      ))
      ..loadRequest(_uri);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: PopScope(
        canPop: false,
        child: Column(
          children: [
            Expanded(
              child: WebViewWidget(
                key: GlobalKey(),
                controller: _ctrl,
              ),
            ),
            Container(
              color: AppTheme.clYellow,
              height: 10,
              width: context.width,
            ),
          ],
        ),
      ),
    );
  }
}
