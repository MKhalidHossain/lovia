import 'dart:async';

import 'package:dio/dio.dart';
import 'package:lovia/core/config/env.dart';

/// Injects `Authorization: Bearer <access>` on every request, and on a 401
/// attempts a single token refresh then retries the original request once.
/// If refresh fails, [onSessionExpired] is invoked (forces logout → auth).
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.readToken,
    required this.readRefreshToken,
    required this.onTokensRefreshed,
    required this.onSessionExpired,
  }) : _refreshDio = Dio(
          BaseOptions(
            baseUrl: Env.apiBaseUrl,
            connectTimeout: Env.networkTimeout,
            receiveTimeout: Env.networkTimeout,
            headers: {'Content-Type': 'application/json'},
            validateStatus: (s) => s != null && s < 500,
          ),
        );

  final Future<String?> Function() readToken;
  final Future<String?> Function() readRefreshToken;
  final Future<void> Function(String access, String refresh) onTokensRefreshed;
  final Future<void> Function() onSessionExpired;

  // Bare client (no auth interceptor) used for refresh + retry — avoids
  // recursing back into this interceptor.
  final Dio _refreshDio;

  // Shared in-flight refresh so concurrent 401s only trigger one refresh.
  Completer<String?>? _inflight;

  static const String _retriedKey = 'lovia_retried';

  bool _isAuthEndpoint(String path) => path.contains('/auth/');

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    final options = response.requestOptions;
    final shouldRefresh = response.statusCode == 401 &&
        options.extra[_retriedKey] != true &&
        !_isAuthEndpoint(options.path);

    if (!shouldRefresh) {
      handler.next(response);
      return;
    }

    final newAccess = await _refreshOnce();
    if (newAccess == null) {
      await onSessionExpired();
      handler.next(response);
      return;
    }

    try {
      final retried = await _retry(options, newAccess);
      handler.resolve(retried);
    } on DioException catch (e) {
      handler.next(e.response ?? response);
    }
  }

  /// Performs a single shared refresh; returns the new access token or null.
  Future<String?> _refreshOnce() {
    final existing = _inflight;
    if (existing != null) return existing.future;

    final completer = Completer<String?>();
    _inflight = completer;

    unawaited(() async {
      try {
        final refresh = await readRefreshToken();
        if (refresh == null || refresh.isEmpty) {
          completer.complete(null);
          return;
        }
        final res = await _refreshDio.post<dynamic>(
          '/auth/refresh',
          data: {'refreshToken': refresh},
        );
        final data = res.data;
        if (res.statusCode == 200 && data is Map<String, dynamic>) {
          final access = data['accessToken'] as String?;
          final newRefresh = data['refreshToken'] as String?;
          if (access != null && newRefresh != null) {
            await onTokensRefreshed(access, newRefresh);
            completer.complete(access);
            return;
          }
        }
        completer.complete(null);
      } on Object catch (_) {
        completer.complete(null);
      } finally {
        _inflight = null;
      }
    }());

    return completer.future;
  }

  Future<Response<dynamic>> _retry(
    RequestOptions options,
    String accessToken,
  ) {
    return _refreshDio.request<dynamic>(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: Options(
        method: options.method,
        headers: {
          ...options.headers,
          'Authorization': 'Bearer $accessToken',
        },
        extra: {...options.extra, _retriedKey: true},
      ),
    );
  }
}
