import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'package:intl/intl.dart';
import 'package:lasitrade/utils/core_utils.dart';

class WebService {
  late tz.Location et;
  late tz.Location pl;

  Future<void> init() async {
    tz.initializeTimeZones();

    et = tz.getLocation('America/New_York');
    pl = tz.getLocation('Europe/Warsaw');
  }

  Future<(Map<String, dynamic>, List<List<dynamic>>)> scrapeSymbol({
    required String symbol,
  }) async {
    final Map<String, dynamic> data = {
      'price': 0.0,
      'price_net': 0.0,
      'price_perc': 0.0,
      //
      'market_cap': 0.0,
      'volume': 0.0,
      'volume_per': 0.0,
      'shs_outstand': 0.0,
      'shs_float': 0.0,
      'shs_float_per': 0.0,
      'short_interest': 0.0,
      'short_ratio': 0.0,
      'short_float': 0.0,
    };

    final List<List<dynamic>> news = [];

    try {
      final response = await http.get(
        Uri.parse('https://finviz.com/quote.ashx?t=$symbol&p=d'),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
              'AppleWebKit/537.36 (KHTML, like Gecko) '
              'Chrome/127.0.0.0 Safari/537.36',
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
          'Accept-Language': 'en-US,en;q=0.9',
          'Connection': 'keep-alive',
        },
      );

      if (response.statusCode == 200) {
        final Document document = parser.parse(response.body);

        //+ price

        final rowPrice = document.querySelector('.quote-price_wrapper_price');
        if (rowPrice != null) {
          data['price'] = double.tryParse(rowPrice.text) ?? 0.0;
        }

        final rowsNetPerc =
            document.querySelector('.quote-price_wrapper_change');
        if (rowsNetPerc != null) {
          final rows123 = rowsNetPerc.querySelectorAll('.table-row');
          final dollarChange = rows123[0].querySelector('span');
          final percentChange = rows123[1].querySelector('span');

          if (dollarChange != null) {
            final valNet = dollarChange.text.replaceAll('Dollar change', '');
            data['price_net'] = double.tryParse(valNet) ?? 0.0;
          }

          if (percentChange != null) {
            final valPerc =
                percentChange.text.replaceAll('Percentage change', '');
            data['price_perc'] = double.tryParse(valPerc) ?? 0.0;
          }
        }

        //+ news

        final newsTable = document.querySelector('#news-table');
        if (newsTable != null) {
          final now = DateTime.now();
          final timeFormat = DateFormat('hh:mma');
          final dateTimeFormat = DateFormat('MMM-dd-yy hh:mma');

          DateTime currentDateContext = DateTime(now.year, now.month, now.day);

          final rows = newsTable.querySelectorAll('.cursor-pointer');
          for (final row in rows) {
            try {
              final time =
                  row.querySelector('td[align="right"]')?.text.trim() ?? '';

              DateTime parsed;

              String cleaned = time.trim();

              if (cleaned.startsWith('Today')) {
                cleaned = cleaned.replaceFirst('Today', '').trim();
                currentDateContext = DateTime(now.year, now.month, now.day);

                final t = timeFormat.parse(cleaned);
                parsed = DateTime(
                    currentDateContext.year,
                    currentDateContext.month,
                    currentDateContext.day,
                    t.hour,
                    t.minute);
              } else if (RegExp(r'[A-Za-z]{3}-\d{2}-\d{2}').hasMatch(cleaned)) {
                // New full date anchor — reset context
                parsed = dateTimeFormat.parse(cleaned);
                currentDateContext =
                    DateTime(parsed.year, parsed.month, parsed.day);
              } else {
                // Use last known context date
                final t = timeFormat.parse(cleaned);
                parsed = DateTime(
                    currentDateContext.year,
                    currentDateContext.month,
                    currentDateContext.day,
                    t.hour,
                    t.minute);
              }

              final etTime = tz.TZDateTime(
                et,
                parsed.year,
                parsed.month,
                parsed.day,
                parsed.hour,
                parsed.minute,
              );

              final plTime = tz.TZDateTime.from(etTime, pl);

              final text =
                  row.querySelector('.tab-link-news')?.text.trim() ?? '';
              final source = row
                      .querySelector('.news-link-right span')
                      ?.text
                      .trim()
                      .replaceAll(RegExp(r'[()]'), '') ??
                  '';
              String link =
                  row.querySelector('.tab-link-news')?.attributes['href'] ?? '';
              if (link.startsWith('/')) {
                link = 'https://finviz.com$link';
              }

              final data = [plTime, text, source, link];
              news.add(data);
            } catch (_) {}
          }
        }

        //+ data

        final elDts =
            document.querySelectorAll('.screener_snapshot-table-body');
        if (elDts.isNotEmpty) {
          final String dataText = elDts[0].text.trim();
          final List<String> dataArr = dataText.split('\n');

          for (var dataIt in dataArr) {
            if (dataIt.startsWith('Market Cap')) {
              data['market_cap'] = fnTryParseHumanNumber(
                dataIt.split('Market Cap').last,
              );
            } else if (dataIt.startsWith('Volume')) {
              String volText = dataIt.split('Volume').last;
              if (volText.contains(',')) {
                volText = volText.replaceAll(',', '');
              }

              data['volume'] = fnTryParseHumanNumber(
                volText,
              );

              data['volume_per'] = double.parse(
                (data['volume'] / data['market_cap'] * 100 as double)
                    .toStringAsFixed(3),
              );
            } else if (dataIt.startsWith('Shs Outstand')) {
              data['shs_outstand'] = fnTryParseHumanNumber(
                dataIt.split('Shs Outstand').last,
              );
            } else if (dataIt.startsWith('Shs Float')) {
              data['shs_float'] = fnTryParseHumanNumber(
                dataIt.split('Shs Float').last,
              );

              data['shs_float_per'] = double.parse(
                (data['shs_float'] / data['shs_outstand'] * 100 as double)
                    .toStringAsFixed(3),
              );
            } else if (dataIt.startsWith('Short Interest')) {
              data['short_interest'] = fnTryParseHumanNumber(
                dataIt.split('Short Interest').last,
              );
            } else if (dataIt.startsWith('Short Ratio')) {
              data['short_ratio'] = double.tryParse(
                dataIt.split('Short Ratio').last,
              );
            } else if (dataIt.startsWith('Short Float')) {
              data['short_float'] = double.tryParse(
                dataIt.split('Short Float').last.replaceAll('%', ''),
              );
            }
          }
        }
      }
    } catch (_) {}

    return (data, news);
  }
}
