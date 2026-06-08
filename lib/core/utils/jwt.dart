import 'dart:convert';

abstract final class Jwt {

  static Map<String, dynamic>? decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    try {
      final normalized = base64Url.normalize(parts[1]);
      final payload = utf8.decode(base64Url.decode(normalized));
      final decoded = jsonDecode(payload);
      return decoded is Map<String, dynamic> ? decoded : null;
    } on FormatException {
      return null;
    }
  }

  static String userId(String token) =>
      decodePayload(token)?['userId']?.toString() ?? '';

  static DateTime? expiry(String token) {
    final exp = decodePayload(token)?['exp'];
    if (exp is! int) return null;
    return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  }

  static bool isExpired(String token) {
    final exp = expiry(token);
    if (exp == null) return false;
    return DateTime.now().isAfter(exp);
  }
}
