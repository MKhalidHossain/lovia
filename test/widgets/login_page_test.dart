import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/features/auth/domain/repositories/auth_repository.dart';
import 'package:lovia/features/auth/domain/usecases/check_auth_status.dart';
import 'package:lovia/features/auth/domain/usecases/get_current_user.dart';
import 'package:lovia/features/auth/domain/usecases/login_user.dart';
import 'package:lovia/features/auth/domain/usecases/logout_user.dart';
import 'package:lovia/features/auth/domain/usecases/register_user.dart';
import 'package:lovia/features/auth/domain/usecases/request_password_reset.dart';
import 'package:lovia/features/auth/domain/usecases/reset_password.dart';
import 'package:lovia/features/auth/domain/usecases/sign_in_as_guest.dart';
import 'package:lovia/features/auth/domain/usecases/sign_in_with_provider.dart';
import 'package:lovia/features/auth/domain/usecases/update_language.dart';
import 'package:lovia/features/auth/domain/usecases/verify_otp.dart';
import 'package:lovia/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lovia/features/auth/presentation/pages/login_page.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repo;

  setUp(() {
    repo = MockAuthRepository();

    Get.put<AuthController>(
      AuthController(
        checkAuthStatus: CheckAuthStatus(repo),
        loginUser: LoginUser(repo),
        registerUser: RegisterUser(repo),
        logoutUser: LogoutUser(repo),
        getCurrentUser: GetCurrentUser(repo),
        requestPasswordReset: RequestPasswordReset(repo),
        verifyOtp: VerifyOtp(repo),
        resetPassword: ResetPassword(repo),
        signInWithProvider: SignInWithProvider(repo),
        signInAsGuest: SignInAsGuest(repo),
        updateLanguage: UpdateLanguage(repo),
      ),
    );
  });

  tearDown(Get.reset);

  Widget harness() => const GetMaterialApp(home: LoginPage());

  testWidgets('shows validation errors when fields are empty', (tester) async {
    await tester.pumpWidget(harness());

    await tester.tap(find.text('Sign in'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    verifyNever(() => repo.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ));
  });

  testWidgets('rejects an invalid email format', (tester) async {
    await tester.pumpWidget(harness());

    await tester.enterText(find.byType(TextField).first, 'not-an-email');
    await tester.enterText(find.byType(TextField).last, 'secret1');
    await tester.tap(find.text('Sign in'));
    await tester.pump();

    expect(find.text('Enter a valid email'), findsOneWidget);
  });

  testWidgets('calls login with valid credentials', (tester) async {

    when(() => repo.login(email: 'a@b.com', password: 'secret1'))
        .thenAnswer((_) async => const Failed(ValidationFailure(message: 'x')));

    await tester.pumpWidget(harness());

    await tester.enterText(find.byType(TextField).first, 'a@b.com');
    await tester.enterText(find.byType(TextField).last, 'secret1');
    await tester.tap(find.text('Sign in'));
    await tester.pump();

    verify(() => repo.login(email: 'a@b.com', password: 'secret1')).called(1);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}
