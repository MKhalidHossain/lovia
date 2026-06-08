import 'package:flutter_test/flutter_test.dart';
import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/auth/domain/entities/user.dart';
import 'package:lovia/features/auth/domain/repositories/auth_repository.dart';
import 'package:lovia/features/auth/domain/usecases/check_auth_status.dart';
import 'package:lovia/features/auth/domain/usecases/get_current_user.dart';
import 'package:lovia/features/auth/domain/usecases/login_user.dart';
import 'package:lovia/features/auth/domain/usecases/logout_user.dart';
import 'package:lovia/features/auth/domain/usecases/register_user.dart';
import 'package:lovia/features/auth/domain/usecases/request_password_reset.dart';
import 'package:lovia/features/auth/domain/usecases/reset_password.dart';
import 'package:lovia/features/auth/domain/usecases/verify_otp.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repo;

  const user = User(id: '1', name: 'Aria', email: 'a@b.com');

  setUp(() => repo = MockAuthRepository());

  test('LoginUser delegates to repository.login and returns the user', () async {
    when(() => repo.login(email: 'a@b.com', password: 'secret'))
        .thenAnswer((_) async => const Success(user));

    final result = await LoginUser(repo)(
      const LoginParams(email: 'a@b.com', password: 'secret'),
    );

    expect(result, isA<Success<User, Failure>>());
    expect((result as Success).value, user);
    verify(() => repo.login(email: 'a@b.com', password: 'secret')).called(1);
  });

  test('LoginUser propagates a failure', () async {
    when(() => repo.login(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => const Failed(ValidationFailure(message: 'bad')));

    final result = await LoginUser(repo)(
      const LoginParams(email: 'x@y.com', password: 'nope'),
    );

    expect(result, isA<Failed<User, Failure>>());
  });

  test('RegisterUser delegates to repository.register', () async {
    when(() => repo.register(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => const Success(Unit.value));

    final result = await RegisterUser(repo)(
      const RegisterParams(name: 'Aria', email: 'a@b.com', password: 'secret'),
    );

    expect(result, isA<Success<Unit, Failure>>());
    verify(() => repo.register(name: 'Aria', email: 'a@b.com', password: 'secret'))
        .called(1);
  });

  test('GetCurrentUser delegates to repository.getCurrentUser', () async {
    when(() => repo.getCurrentUser()).thenAnswer((_) async => const Success(user));
    final result = await GetCurrentUser(repo)(const NoParams());
    expect((result as Success).value, user);
  });

  test('CheckAuthStatus delegates to repository.checkAuthStatus', () async {
    when(() => repo.checkAuthStatus())
        .thenAnswer((_) async => const Failed(UnauthorizedFailure()));
    final result = await CheckAuthStatus(repo)(const NoParams());
    expect(result, isA<Failed<User, Failure>>());
  });

  test('LogoutUser delegates to repository.logout', () async {
    when(() => repo.logout()).thenAnswer((_) async => const Success(Unit.value));
    final result = await LogoutUser(repo)(const NoParams());
    expect(result, isA<Success<Unit, Failure>>());
    verify(() => repo.logout()).called(1);
  });

  test('RequestPasswordReset delegates to repository', () async {
    when(() => repo.requestPasswordReset(email: any(named: 'email')))
        .thenAnswer((_) async => const Success(Unit.value));
    final result = await RequestPasswordReset(repo)('a@b.com');
    expect(result, isA<Success<Unit, Failure>>());
    verify(() => repo.requestPasswordReset(email: 'a@b.com')).called(1);
  });

  test('VerifyOtp delegates to repository', () async {
    when(() => repo.verifyOtp(email: any(named: 'email'), otp: any(named: 'otp')))
        .thenAnswer((_) async => const Success(Unit.value));
    final result =
        await VerifyOtp(repo)(const VerifyOtpParams(email: 'a@b.com', otp: '123456'));
    expect(result, isA<Success<Unit, Failure>>());
  });

  test('ResetPassword delegates to repository', () async {
    when(() => repo.resetPassword(
          email: any(named: 'email'),
          otp: any(named: 'otp'),
          newPassword: any(named: 'newPassword'),
        )).thenAnswer((_) async => const Success(Unit.value));
    final result = await ResetPassword(repo)(
      const ResetPasswordParams(
        email: 'a@b.com',
        otp: '123456',
        newPassword: 'newpass',
      ),
    );
    expect(result, isA<Success<Unit, Failure>>());
  });
}
