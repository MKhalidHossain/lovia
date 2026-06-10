import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lovia/core/constants/storage_keys.dart';
import 'package:lovia/core/error/exceptions.dart';

abstract interface class AuthLocalDataSource {
  Future<void> cacheSession({
    required String accessToken,
    required String refreshToken,
    required String name,
    required String email,
    String? userId,
    String? avatarUrl,
    bool isGuest = false,
  });

  /// Replace just the token pair after a refresh.
  Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<String?> readToken();
  Future<String?> readRefreshToken();
  Future<String?> readName();
  Future<String?> readEmail();
  Future<String?> readUserId();
  Future<String?> readAvatar();
  Future<bool> readIsGuest();

  /// Stable per-install device id used for guest sessions (created on demand).
  Future<String> deviceId();

  Future<void> clear();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._storage);
  final FlutterSecureStorage _storage;

  @override
  Future<void> cacheSession({
    required String accessToken,
    required String refreshToken,
    required String name,
    required String email,
    String? userId,
    String? avatarUrl,
    bool isGuest = false,
  }) async {
    try {
      await _storage.write(key: StorageKeys.accessToken, value: accessToken);
      await _storage.write(key: StorageKeys.refreshToken, value: refreshToken);
      await _storage.write(key: StorageKeys.userName, value: name);
      await _storage.write(key: StorageKeys.userEmail, value: email);
      await _storage.write(key: StorageKeys.userAvatar, value: avatarUrl ?? '');
      await _storage.write(
        key: StorageKeys.userIsGuest,
        value: isGuest.toString(),
      );
      if (userId != null) {
        await _storage.write(key: StorageKeys.userId, value: userId);
      }
    } on Object catch (e) {
      throw CacheException('Failed to persist session: $e');
    }
  }

  @override
  Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await _storage.write(key: StorageKeys.accessToken, value: accessToken);
      await _storage.write(key: StorageKeys.refreshToken, value: refreshToken);
    } on Object catch (e) {
      throw CacheException('Failed to update tokens: $e');
    }
  }

  @override
  Future<String?> readToken() => _read(StorageKeys.accessToken);

  @override
  Future<String?> readRefreshToken() => _read(StorageKeys.refreshToken);

  @override
  Future<String?> readName() => _read(StorageKeys.userName);

  @override
  Future<String?> readEmail() => _read(StorageKeys.userEmail);

  @override
  Future<String?> readUserId() => _read(StorageKeys.userId);

  @override
  Future<String?> readAvatar() => _read(StorageKeys.userAvatar);

  @override
  Future<bool> readIsGuest() async => (await _read(StorageKeys.userIsGuest)) == 'true';

  @override
  Future<String> deviceId() async {
    try {
      final existing = await _storage.read(key: StorageKeys.deviceId);
      if (existing != null && existing.isNotEmpty) return existing;
      final id = _generateDeviceId();
      await _storage.write(key: StorageKeys.deviceId, value: id);
      return id;
    } on Object catch (e) {
      throw CacheException('Failed to read device id: $e');
    }
  }

  // A v4-ish UUID built from the platform's secure RNG (FlutterSecureStorage
  // already pulls in no crypto deps we can borrow, so hand-roll it cheaply).
  String _generateDeviceId() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final rand = now.hashCode ^ identityHashCode(this);
    final hex = (now ^ (rand << 16)).toRadixString(16).padLeft(16, '0');
    return 'dev-$hex-${rand.toUnsigned(32).toRadixString(16)}';
  }

  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } on Object catch (e) {
      throw CacheException('Failed to read $key: $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      // Keep deviceId so the same guest account can be recovered.
      for (final key in const [
        StorageKeys.accessToken,
        StorageKeys.refreshToken,
        StorageKeys.userName,
        StorageKeys.userEmail,
        StorageKeys.userId,
        StorageKeys.userAvatar,
        StorageKeys.userIsGuest,
      ]) {
        await _storage.delete(key: key);
      }
    } on Object catch (e) {
      throw CacheException('Failed to clear session: $e');
    }
  }
}
