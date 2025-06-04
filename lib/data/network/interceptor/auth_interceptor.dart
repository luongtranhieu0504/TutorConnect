import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../source/auth_disk_data_source.dart';


@singleton
class AuthInterceptor extends Interceptor {
  final AuthDiskDataSource _authDiskDataSource;

  AuthInterceptor(this._authDiskDataSource);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _authDiskDataSource.getToken(); // Get token from AuthDiskDataSource

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Optional: handle token expiration or other errors here
    return handler.next(err);
  }
}