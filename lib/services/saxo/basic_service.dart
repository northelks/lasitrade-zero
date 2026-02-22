import 'package:lasitrade/getit.dart';
import 'package:lasitrade/models/saxo/saxo_country_model.dart';
import 'package:lasitrade/models/saxo/saxo_culture_model.dart';
import 'package:lasitrade/models/saxo/saxo_currency_model.dart';
import 'package:lasitrade/models/saxo/saxo_language_model.dart';
import 'package:lasitrade/models/saxo/saxo_time_zone_model.dart';

class BasicService {
  Future<List<SaxoLanguageModel>> getLanguages() async {
    final res = await dioCl.get('/ref/v1/languages');
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(res.data['Data'])
          .map((it) => SaxoLanguageModel.fromJson(it))
          .toList();
    }

    return [];
  }

  Future<List<SaxoCultureModel>> getCultures() async {
    final res = await dioCl.get('/ref/v1/cultures');
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(res.data['Data'])
          .map((it) => SaxoCultureModel.fromJson(it))
          .toList();
    }

    return [];
  }

  Future<List<SaxoTimeZoneModel>> getTimeZones() async {
    final res = await dioCl.get('/ref/v1/timezones');
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(res.data['Data'])
          .map((it) => SaxoTimeZoneModel.fromJson(it))
          .toList();
    }

    return [];
  }

  Future<List<SaxoCountryModel>> getCountries() async {
    final res = await dioCl.get('/ref/v1/countries');
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(res.data['Data'])
          .map((it) => SaxoCountryModel.fromJson(it))
          .toList();
    }

    return [];
  }

  Future<List<SaxoCurrencyModel>> getCurrencies() async {
    final res = await dioCl.get('/ref/v1/currencies');
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(res.data['Data'])
          .map((it) => SaxoCurrencyModel.fromJson(it))
          .toList();
    }

    return [];
  }

  //+ diagnostics

  Future<Map<String, bool>> diagnosticRequests() async {
    final res1 = await dioCl.get('/root/v1/diagnostics/get');
    final res2 = await dioCl.post('/root/v1/diagnostics/post');
    final res3 = await dioCl.put('/root/v1/diagnostics/put');
    final res4 = await dioCl.patch('/root/v1/diagnostics/patch');
    final res5 = await dioCl.delete('/root/v1/diagnostics/delete');

    return {
      'GET': res1.statusCode == 200,
      'POST': res2.statusCode == 200,
      'PUT': res3.statusCode == 200,
      'PATCH': res4.statusCode == 200,
      'DELETE': res5.statusCode == 200,
    };
  }
}
