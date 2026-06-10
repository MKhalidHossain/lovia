import 'package:lovia/core/error/exceptions.dart';
import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/utils/jwt.dart';
import 'package:lovia/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:lovia/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lovia/features/auth/data/datasources/auth_social_data_source.dart';
import 'package:lovia/features/auth/data/models/auth_response_model.dart';
import 'package:lovia/features/auth/domain/entities/auth_provider.dart';
import 'package:lovia/features/auth/domain/entities/user.dart';
import 'package:lovia/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
    required AuthSocialDataSource social,
  })  : _remote = remote,
        _local = local,
        _social = social;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final AuthSocialDataSource _social;

  // Sentinel token for an offline-only guest session (not a real JWT).
  static const String _offlineGuestToken = 'lovia-offline-guest';

  @override
  Future<Result<Unit, Failure>> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _guard(() async {
      // Backend creates the account (and returns a session we don't cache —
      // the user signs in explicitly on the next screen).
      await _remote.register(name: name, email: email, password: password);
      return Unit.value;
    });
  }

  @override
  Future<Result<User, Failure>> login({
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final res = await _remote.login(email: email, password: password);
      await _cache(res);
      return res.user.toEntity();
    });
  }

  @override
  Future<Result<User, Failure>> signInWithProvider(AuthProvider provider) {
    return _guard(() async {
      final cred = await _social.signIn(provider);
      final res = switch (provider) {
        AuthProvider.google =>
          await _remote.google(idToken: cred.idToken ?? ''),
        AuthProvider.facebook =>
          await _remote.facebook(accessToken: cred.accessToken ?? ''),
        _ => throw const UnauthorizedException('Unsupported provider'),
      };
      await _cache(res);
      return res.user.toEntity();
    });
  }

  @override
  Future<Result<User, Failure>> loginAsGuest() {
    return _guard(() async {
      final deviceId = await _local.deviceId();
      try {
        final res = await _remote.guest(deviceId: deviceId);
        await _cache(res);
        return res.user.toEntity();
      } on NetworkException {
        // Offline-tolerant: fall back to a local-only guest session.
        final id = 'guest-${deviceId.hashCode.toUnsigned(32)}';
        await _local.cacheSession(
          accessToken: _offlineGuestToken,
          refreshToken: _offlineGuestToken,
          name: 'Guest',
          email: '',
          userId: id,
          isGuest: true,
        );
        // Surface as a soft failure carrying the offline guest so the
        // controller can still proceed while toasting.
        throw const _OfflineGuestSignal();
      }
    });
  }

  @override
  Future<Result<User, Failure>> getCurrentUser() {
    return _guard(() async {
      try {
        final me = await _remote.getMe();
        await _local.cacheSession(
          accessToken: (await _local.readToken()) ?? '',
          refreshToken: (await _local.readRefreshToken()) ?? '',
          name: me.name,
          email: me.email ?? '',
          userId: me.id,
          avatarUrl: me.avatarUrl,
          isGuest: me.isGuest,
        );
        return me.toEntity();
      } on NetworkException {
        return _cachedUserOrThrow();
      }
    });
  }

  @override
  Future<Result<User, Failure>> checkAuthStatus() {
    return _guard(() async {
      final token = await _local.readToken();
      if (token == null || token.isEmpty) {
        throw const UnauthorizedException('No active session.');
      }
      // Offline guest sentinel — always treated as a valid local session.
      if (token == _offlineGuestToken) return _cachedUserOrThrow();

      if (Jwt.isExpired(token)) {
        // Access token expired — the AuthInterceptor will refresh on the next
        // authenticated call; here we just trust a present refresh token.
        final refresh = await _local.readRefreshToken();
        if (refresh == null || refresh.isEmpty) {
          await _local.clear();
          throw const UnauthorizedException('Session expired.');
        }
      }
      return _cachedUserOrThrow();
    });
  }

  @override
  Future<Result<User, Failure>> updateLanguage(String language) {
    return _guard(() async {
      try {
        final me = await _remote.updateProfile(language: language);
        return me.toEntity();
      } on NetworkException {
        return _cachedUserOrThrow();
      }
    });
  }

  @override
  Future<Result<Unit, Failure>> logout() {
    return _guard(() async {
      // Best-effort server logout + SDK sign-out; local clear always runs.
      try {
        await _remote.logout();
      } on Object catch (_) {}
      try {
        await _social.signOut();
      } on Object catch (_) {}
      await _local.clear();
      return Unit.value;
    });
  }

  @override
  Future<Result<Unit, Failure>> requestPasswordReset({required String email}) {
    return _guard(() async {
      await _remote.requestPasswordReset(email: email);
      return Unit.value;
    });
  }

  @override
  Future<Result<Unit, Failure>> verifyOtp({
    required String email,
    required String otp,
  }) {
    return _guard(() async {
      await _remote.verifyOtp(email: email, otp: otp);
      return Unit.value;
    });
  }

  @override
  Future<Result<Unit, Failure>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) {
    return _guard(() async {
      await _remote.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      return Unit.value;
    });
  }

  Future<void> _cache(AuthResponseModel res) {
    return _local.cacheSession(
      accessToken: res.accessToken,
      refreshToken: res.refreshToken,
      name: res.user.name,
      email: res.user.email ?? '',
      userId: res.user.id,
      avatarUrl: res.user.avatarUrl,
      isGuest: res.user.isGuest,
    );
  }

  Future<User> _cachedUserOrThrow() async {
    final token = await _local.readToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException('No active session.');
    }
    return User(
      id: (await _local.readUserId()) ?? '',
      name: (await _local.readName()) ?? '',
      email: (await _local.readEmail()) ?? '',
      avatarUrl: (await _local.readAvatar())?.nullIfEmpty,
      isGuest: await _local.readIsGuest(),
    );
  }

  Future<Result<T, Failure>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on _OfflineGuestSignal {
      final user = await _cachedUserOrThrow();
      return Success(user as T);
    } on NetworkException catch (e) {
      return Failed(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Failed(UnauthorizedFailure(e.message));
    } on CacheException catch (e) {
      return Failed(CacheFailure(e.message));
    } on ServerException catch (e) {
      if (e.code >= 400 && e.code < 500) {
        return Failed(ValidationFailure(message: e.message));
      }
      return Failed(ServerFailure(code: e.code, message: e.message));
    } on Object catch (e) {
      return Failed(UnknownFailure('Unexpected error: $e'));
    }
  }
}

/// Internal signal: guest sign-in failed online but a local guest session was
/// created. Caught in [AuthRepositoryImpl._guard] to return that guest.
class _OfflineGuestSignal implements Exception {
  const _OfflineGuestSignal();
}

extension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}
