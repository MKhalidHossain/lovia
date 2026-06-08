class NetworkException implements Exception {
  const NetworkException([this.message = 'Network error']);
  final String message;
}

class ServerException implements Exception {
  const ServerException({required this.code, required this.message});
  final int code;
  final String message;
}

class UnauthorizedException implements Exception {
  const UnauthorizedException([this.message = 'Unauthorized']);
  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Cache error']);
  final String message;
}
