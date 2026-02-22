import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:lasitrade/constants.dart';
import 'package:lasitrade/logger.dart';
import 'package:lasitrade/route.dart';
import 'package:lasitrade/utils/core_utils.dart';
import 'package:lasitrade/utils/pref_utils.dart';

class AuthService {
  Future<String?> parseUrlCode(String url) async {
    final uri = Uri.parse(url);

    final queryParameters = uri.queryParameters;
    if (queryParameters.keys.contains('error')) {
      final error = queryParameters['error']!;
      throw AppError(message: error, code: AppErrorCode.er404);
    } else if (queryParameters.keys.contains('code')) {
      return queryParameters['code']!;
    }

    return null;
  }

  Future<bool> fetchTokens(String code) async {
    final String base64String = base64.encode(
      utf8.encode(fnDotEnv('CODE_KEY')),
    );

    final res = await Dio().post(
      cstApiTokenUrl,
      options: Options(
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Authorization': 'Basic $base64String',
        },
      ),
      data: {
        'grant_type': "authorization_code",
        'code': code,
      },
    );

    if (res.statusCode == 201) {
      await fnPrefSaveAccessToken(
        res.data['access_token'],
        res.data['expires_in'],
      );
      await fnPrefSaveRefreshToken(
        res.data['refresh_token'],
        res.data['refresh_token_expires_in'],
      );

      return true;
    }

    return false;
  }

  Future<bool> refreshTokens() async {
    try {
      final String base64String = base64.encode(
        utf8.encode(fnDotEnv('CODE_KEY')),
      );

      final res = await Dio().post(
        cstApiTokenUrl,
        options: Options(
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            'Authorization': 'Basic $base64String',
          },
        ),
        data: {
          'grant_type': "refresh_token",
          'refresh_token': await fnPrefGetRefreshToken(),
        },
      );

      if (res.statusCode == 201) {
        await fnPrefSaveAccessToken(
          res.data['access_token'],
          res.data['expires_in'],
        );
        await fnPrefSaveRefreshToken(
          res.data['refresh_token'],
          res.data['refresh_token_expires_in'],
        );

        return true;
      }
    } catch (error) {
      dprint(error);
    }

    return false;
  }

  Future<bool> validateTokens({bool silence = false}) async {
    final accessToken = await fnPrefGetAccessToken();
    if (accessToken.isEmpty) {
      AppRoute.goTo(AppRoute.srLogin);
      return false;
    }

    final isAccessExpired = await fnPrefIfAccessTokenExpired();
    if (isAccessExpired) {
      final refreshToken = await fnPrefGetRefreshToken();
      final isRefreshExpired = await fnPrefIfRefreshTokenExpired();
      if (refreshToken.isNotEmpty && isRefreshExpired) {
        AppRoute.goTo(AppRoute.srLogin);
        return false;
      } else {
        final isOk = await refreshTokens();
        if (!isOk) {
          if (silence) return true;

          AppRoute.goTo(AppRoute.srLogin);
          return false;
        }
      }
    }

    return true;
  }
}
