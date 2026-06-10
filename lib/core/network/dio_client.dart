import 'package:dio/dio.dart';
import 'package:lovia/core/config/env.dart';
import 'package:lovia/core/network/interceptors/auth_interceptor.dart';
import 'package:lovia/core/network/interceptors/log_interceptor.dart';

class DioClient {
  DioClient({
    required Future<String?> Function() tokenProvider,
    required Future<String?> Function() refreshTokenProvider,
    required Future<void> Function(String access, String refresh) onTokensRefreshed,
    required Future<void> Function() onSessionExpired,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: Env.apiBaseUrl,
            connectTimeout: Env.networkTimeout,
            receiveTimeout: Env.networkTimeout,
            sendTimeout: Env.networkTimeout,
            headers: {'Content-Type': 'application/json'},
            validateStatus: (status) => status != null && status < 500,
          ),
        ) {
    _dio.interceptors.addAll([
      AppLogInterceptor(),
      AuthInterceptor(
        readToken: tokenProvider,
        readRefreshToken: refreshTokenProvider,
        onTokensRefreshed: onTokensRefreshed,
        onSessionExpired: onSessionExpired,
      ),
    ]);
  }

  final Dio _dio;
  Dio get dio => _dio;
}
