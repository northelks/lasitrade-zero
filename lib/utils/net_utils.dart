import 'package:dio/dio.dart';

import 'package:lasitrade/constants.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/logger.dart';
import 'package:lasitrade/utils/pref_utils.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio();
    _dio
      ..options.baseUrl = cstApiUrl
      ..options.headers = {'Content-Type': 'application/json'}
      ..options.connectTimeout = const Duration(milliseconds: 90000)
      ..options.receiveTimeout = const Duration(milliseconds: 90000)
      ..options.responseType = ResponseType.json;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['Authorization'] =
              'Bearer ${await fnPrefGetAccessToken()}';
          options.headers['Content-Type'] = 'application/json';

          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response<dynamic>> get(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _fnDio(
      () => _dio.get(
        url,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<Response<dynamic>> post(
    String uri, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _fnDio(
      () => _dio.post(
        uri,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<Response<dynamic>> put(
    String uri, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _fnDio(
      () => _dio.put(
        uri,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<Response<dynamic>> patch(
    String uri, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _fnDio(
      () => _dio.patch(
        uri,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<dynamic> delete(
    String uri, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _fnDio(
      () => _dio.delete(
        uri,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  // INTF

  Future<dynamic> _fnDio(
    Future<dynamic> Function() fn,
  ) async {
    try {
      return await fn();
    } on DioException catch (error) {
      if (error.response?.statusMessage == 'Unauthorized') {
        await authServ.validateTokens();
        return await fn();
      } else {
        if (error.response?.statusCode != 429) {
          dprint(error.response.toString());
        }

        rethrow;
      }
    }
  }
}
