import 'package:dio/dio.dart';
import 'package:lovia/core/constants/api_paths.dart';
import 'package:lovia/core/error/exceptions.dart';
import 'package:lovia/features/auth/data/models/auth_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<void> register({
    required String name,
    required String email,
    required String password,
  });
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });
  Future<void> requestPasswordReset({required String email});
  Future<void> verifyOtp({required String email, required String otp});
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _post(
      ApiPaths.register,
      {'name': name, 'email': email, 'password': password},
    );
  }

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final data = await _post(
      ApiPaths.login,
      {'email': email, 'password': password},
    );
    return AuthResponseModel.fromJson(data);
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    await _post(ApiPaths.forgotPassword, {'email': email});
  }

  @override
  Future<void> verifyOtp({required String email, required String otp}) async {
    await _post(ApiPaths.verifyOtp, {'email': email, 'otp': otp});
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    await _post(
      ApiPaths.resetPassword,
      {'email': email, 'otp': otp, 'newPassword': newPassword},
    );
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final Response<dynamic> response;
    try {
      response = await _dio.post<dynamic>(path, data: body);
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException(e.message ?? 'Network error');
      }
      throw _mapStatus(e.response!);
    }

    final status = response.statusCode ?? 0;
    if (status >= 200 && status < 300) {
      final data = response.data;
      return data is Map<String, dynamic> ? data : <String, dynamic>{};
    }
    throw _mapStatus(response);
  }

  Exception _mapStatus(Response<dynamic> response) {
    final status = response.statusCode ?? 0;
    final message = _extractMessage(response.data) ?? 'Request failed';
    if (status == 401) return UnauthorizedException(message);
    return ServerException(code: status, message: message);
  }

  String? _extractMessage(dynamic data) {
    if (data is Map) {
      final msg = data['message'] ?? data['error'];
      if (msg is String) return msg;
    }
    return null;
  }
}
