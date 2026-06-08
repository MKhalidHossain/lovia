import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lovia/core/constants/storage_keys.dart';
import 'package:lovia/core/error/exceptions.dart';

abstract interface class AuthLocalDataSource {
  Future<void> cacheSession({
    required String token,
    required String name,
    required String email,
    String? userId,
  });
  Future<String?> readToken();
  Future<String?> readName();
  Future<String?> readEmail();
  Future<String?> readUserId();
  Future<void> clear();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._storage);
  final FlutterSecureStorage _storage;

  @override
  Future<void> cacheSession({
    required String token,
    required String name,
    required String email,
    String? userId,
  }) async {
    try {
      await _storage.write(key: StorageKeys.accessToken, value: token);
      await _storage.write(key: StorageKeys.userName, value: name);
      await _storage.write(key: StorageKeys.userEmail, value: email);
      if (userId != null) {
        await _storage.write(key: StorageKeys.userId, value: userId);
      }
    } on Object catch (e) {
      throw CacheException('Failed to persist session: $e');
    }
  }

  @override
  Future<String?> readToken() => _read(StorageKeys.accessToken);

  @override
  Future<String?> readName() => _read(StorageKeys.userName);

  @override
  Future<String?> readEmail() => _read(StorageKeys.userEmail);

  @override
  Future<String?> readUserId() => _read(StorageKeys.userId);

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
      await _storage.delete(key: StorageKeys.accessToken);
      await _storage.delete(key: StorageKeys.userName);
      await _storage.delete(key: StorageKeys.userEmail);
      await _storage.delete(key: StorageKeys.userId);
    } on Object catch (e) {
      throw CacheException('Failed to clear session: $e');
    }
  }
}
