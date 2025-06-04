import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../config/app_config.dart';
import 'interceptor/auth_interceptor.dart';

@singleton
class Client {
  static const _connectTimeout = 60 * 1000;
  static const _receiveTimeout = 60 * 1000;
  static const _sendTimeout = 60 * 1000;

  static Dio getDio() {
    final dio = Dio();

    dio.options
      ..baseUrl = AppConfig.baseUrl
      ..contentType = Headers.jsonContentType
      ..connectTimeout = const Duration(milliseconds: _connectTimeout)
      ..receiveTimeout = const Duration(milliseconds: _receiveTimeout)
      ..sendTimeout = const Duration(milliseconds: _sendTimeout);

    return dio;
  }

  static LogInterceptor getLogInterceptor() {
    return LogInterceptor(
      requestBody: true,
      responseBody: true,
    );
  }

  final AuthInterceptor _authInterceptor;

  Client(
      this._authInterceptor,
      );

  Dio build() {
    final dio = getDio();
    dio.interceptors
      ..add(_authInterceptor)
      ..add(getLogInterceptor());
    return dio;
  }
}