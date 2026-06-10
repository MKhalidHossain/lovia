import 'package:dio/dio.dart';
import 'package:lovia/core/constants/api_paths.dart';
import 'package:lovia/core/error/exceptions.dart';
import 'package:lovia/features/auth/data/models/auth_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  });
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });
  Future<AuthResponseModel> google({required String idToken});
  Future<AuthResponseModel> facebook({required String accessToken});
  Future<AuthResponseModel> guest({required String deviceId});
  Future<TokenPairModel> refresh({required String refreshToken});
  Future<void> logout();
  Future<UserModel> getMe();
  Future<UserModel> updateProfile({String? language, String? name});
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
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final data = await _send(
      ApiPaths.register,
      body: {'name': name, 'email': email, 'password': password},
    );
    return AuthResponseModel.fromJson(data);
  }

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final data = await _send(
      ApiPaths.login,
      body: {'email': email, 'password': password},
    );
    return AuthResponseModel.fromJson(data);
  }

  @override
  Future<AuthResponseModel> google({required String idToken}) async {
    final data = await _send(ApiPaths.google, body: {'idToken': idToken});
    return AuthResponseModel.fromJson(data);
  }

  @override
  Future<AuthResponseModel> facebook({required String accessToken}) async {
    final data = await _send(
      ApiPaths.facebook,
      body: {'accessToken': accessToken},
    );
    return AuthResponseModel.fromJson(data);
  }

  @override
  Future<AuthResponseModel> guest({required String deviceId}) async {
    final data = await _send(ApiPaths.guest, body: {'deviceId': deviceId});
    return AuthResponseModel.fromJson(data);
  }

  @override
  Future<TokenPairModel> refresh({required String refreshToken}) async {
    final data = await _send(
      ApiPaths.refresh,
      body: {'refreshToken': refreshToken},
    );
    return TokenPairModel.fromJson(data);
  }

  @override
  Future<void> logout() async {
    await _send(ApiPaths.logout, body: const {});
  }

  @override
  Future<UserModel> getMe() async {
    final data = await _send(ApiPaths.usersMe, method: 'GET');
    return UserModel.fromJson(data);
  }

  @override
  Future<UserModel> updateProfile({String? language, String? name}) async {
    final body = <String, dynamic>{};
    if (language != null) body['language'] = language;
    if (name != null) body['name'] = name;
    final data = await _send(ApiPaths.usersMe, method: 'PATCH', body: body);
    return UserModel.fromJson(data);
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    await _send(ApiPaths.forgotPassword, body: {'email': email});
  }

  @override
  Future<void> verifyOtp({required String email, required String otp}) async {
    await _send(ApiPaths.verifyOtp, body: {'email': email, 'otp': otp});
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    await _send(
      ApiPaths.resetPassword,
      body: {'email': email, 'otp': otp, 'newPassword': newPassword},
    );
  }

  Future<Map<String, dynamic>> _send(
    String path, {
    String method = 'POST',
    Map<String, dynamic>? body,
  }) async {
    final Response<dynamic> response;
    try {
      response = await _dio.request<dynamic>(
        path,
        data: body,
        options: Options(method: method),
      );
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
