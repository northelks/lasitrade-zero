import 'package:flutter/material.dart';

import 'package:lasitrade/shadcn.dart';

const String cstSentryDSN =
    "https://0a9952582e7fd77c15b9d1f6896e0964@o4508694635806720.ingest.de.sentry.io/4510556384526416";

const String cstApiUrl = 'https://gateway.saxobank.com/openapi';

const String cstApiTokenUrl = 'https://live.logonvalidation.net/token';
const String cstApiAuthUrl = 'https://live.logonvalidation.net/authorize';

const String cstApiStreamUrl =
    'wss://streaming.saxobank.com/openapi/streamingws/connect';

const String cstStreamId = 'NB_STREAM_ID';

const Map<String, IconData> cstTabs = {
  'home': BootstrapIcons.columnsGap,
  'reports': BootstrapIcons.calendar4Range,
  'watchlists': BootstrapIcons.inputCursor,
  'messages': BootstrapIcons.chatRightText,
  //
  'settings': BootstrapIcons.gearWideConnected,
};

const int cstScreenerPriceFrom = 2;
const int cstScreenerPriceTo = 20;
