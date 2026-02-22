import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:yaml/yaml.dart';

import 'package:lasitrade/getit.dart';
import 'package:lasitrade/context.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  YamlMap? _yaml;

  @override
  void initState() {
    scheduleMicrotask(_initVMs);

    super.initState();
  }

  Future<void> _initVMs() async {
    appContext = context;

    _yaml = loadYaml(await rootBundle.loadString('pubspec.yaml'));

    setState(() {});

    await appVM.init1();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: AppTheme.clBlack,
        width: context.width,
        height: context.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_sq.png',
              width: 320,
              height: 320,
            ),
            100.h,
            if (_yaml != null)
              Column(
                children: [
                  Text(
                    'LasiTrade',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppTheme.clText07,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ).mono,
                  10.h,
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
                  10.h,
                  Text(
                    '...',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.clText03,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ).mono,
                  10.h,
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
          ],
        ),
      ),
    );
  }
}
