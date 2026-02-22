import 'dart:convert';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:lasitrade/constants.dart';

final EncryptedSharedPreferences _storage = EncryptedSharedPreferences();

Future<void> fnPrefClearAll() async {
  await _storage.clear();
}

//+ access token

Future<void> fnPrefSaveAccessToken(String value, int expires) async {
  final dt = DateTime.now().add(Duration(seconds: expires - 30));

  await _storage.setString('ACCESS_TOKEN', value);
  await _storage.setString('ACCESS_TOKEN_EXPIRE', dt.toIso8601String());
}

Future<String> fnPrefGetAccessToken() async {
  return await _storage.getString('ACCESS_TOKEN');
}

Future<DateTime?> fnPrefGetAccessTokenExpired() async {
  return DateTime.tryParse(
    await _storage.getString('ACCESS_TOKEN_EXPIRE'),
  );
}

Future<bool> fnPrefIfAccessTokenExpired() async {
  final dt = DateTime.tryParse(
    await _storage.getString('ACCESS_TOKEN_EXPIRE'),
  );
  if (dt != null) {
    return DateTime.now().difference(dt).inSeconds > 0;
  }

  return true;
}

//+ refresh token

Future<void> fnPrefSaveRefreshToken(String value, int expires) async {
  final dt = DateTime.now().add(Duration(seconds: expires - 30));

  await _storage.setString('REFRESH_TOKEN', value);
  await _storage.setString('REFRESH_TOKEN_EXPIRE', dt.toIso8601String());
}

Future<String> fnPrefGetRefreshToken() async {
  return await _storage.getString('REFRESH_TOKEN');
}

Future<DateTime?> fnPrefGetRefreshTokenExpired() async {
  return DateTime.tryParse(
    await _storage.getString('REFRESH_TOKEN_EXPIRE'),
  );
}

Future<bool> fnPrefIfRefreshTokenExpired() async {
  final dt = DateTime.tryParse(
    await _storage.getString('REFRESH_TOKEN_EXPIRE'),
  );
  if (dt != null) {
    return DateTime.now().difference(dt).inSeconds > 0;
  }

  return true;
}

//+ screener settings

Future<void> fnPrefSaveScreener(Map<String, dynamic> value) async {
  await _storage.setString('SCREENER', jsonEncode(value));
}

Future<Map<String, dynamic>> fnPrefGetScreener() async {
  final val = await _storage.getString('SCREENER');

  return val.isNotEmpty
      ? jsonDecode(val)
      : {
          'price_from': cstScreenerPriceFrom,
          'price_to': cstScreenerPriceTo,
        };
}
