import 'package:lovia/core/error/exceptions.dart';
import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/utils/jwt.dart';
import 'package:lovia/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:lovia/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lovia/features/auth/data/datasources/auth_social_data_source.dart';
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

  static const String _localToken = 'lovia-local-session';

  @override
  Future<Result<Unit, Failure>> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _guard(() async {
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
      await _local.cacheSession(
        token: res.token,
        name: res.name,
        email: email,
        userId: Jwt.userId(res.token),
      );
      return User(id: Jwt.userId(res.token), name: res.name, email: email);
    });
  }

  @override
  Future<Result<User, Failure>> signInWithProvider(AuthProvider provider) {
    return _guard(() async {
      final account = await _social.signIn(provider);
      await _local.cacheSession(
        token: _localToken,
        name: account.name,
        email: account.email,
        userId: account.id,
      );
      return User(id: account.id, name: account.name, email: account.email);
    });
  }

  @override
  Future<Result<User, Failure>> loginAsGuest() {
    return _guard(() async {
      final id = 'guest-${DateTime.now().millisecondsSinceEpoch}';
      await _local.cacheSession(
        token: _localToken,
        name: 'Guest',
        email: '',
        userId: id,
      );
      return User(id: id, name: 'Guest', email: '');
    });
  }

  @override
  Future<Result<User, Failure>> getCurrentUser() => _cachedUser();

  @override
  Future<Result<User, Failure>> checkAuthStatus() => _cachedUser();

  Future<Result<User, Failure>> _cachedUser() {
    return _guard(() async {
      final token = await _local.readToken();
      if (token == null || token.isEmpty || Jwt.isExpired(token)) {
        await _local.clear();
        throw const UnauthorizedException('No active session.');
      }
      final name = await _local.readName() ?? '';
      final email = await _local.readEmail() ?? '';
      final storedId = await _local.readUserId();
      final id = (storedId == null || storedId.isEmpty)
          ? Jwt.userId(token)
          : storedId;
      return User(id: id, name: name, email: email);
    });
  }

  @override
  Future<Result<Unit, Failure>> logout() {
    return _guard(() async {
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

  Future<Result<T, Failure>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
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
