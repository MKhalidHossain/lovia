import 'package:dio/dio.dart';
import 'package:lovia/core/utils/app_logger.dart';

class AppLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.d('→ ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    AppLogger.d('← ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.w(
      '✗ ${err.response?.statusCode ?? '-'} ${err.requestOptions.uri} '
      '(${err.type.name})',
    );
    handler.next(err);
  }
}
