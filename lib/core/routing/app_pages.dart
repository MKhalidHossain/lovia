import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/routing/middleware/auth_middleware.dart';
import 'package:lovia/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:lovia/features/auth/presentation/pages/login_page.dart';
import 'package:lovia/features/auth/presentation/pages/onboarding_page.dart';
import 'package:lovia/features/auth/presentation/pages/reset_password_page.dart';
import 'package:lovia/features/auth/presentation/pages/signup_page.dart';
import 'package:lovia/features/auth/presentation/pages/splash_page.dart';
import 'package:lovia/features/auth/presentation/pages/verify_otp_page.dart';
import 'package:lovia/features/auth/presentation/pages/welcome_page.dart';
import 'package:lovia/features/character/presentation/bindings/character_detail_binding.dart';
import 'package:lovia/features/character/presentation/pages/character_detail_page.dart';
import 'package:lovia/features/chat/presentation/bindings/chat_binding.dart';
import 'package:lovia/features/chat/presentation/pages/chat_page.dart';
import 'package:lovia/features/discover/presentation/bindings/search_binding.dart';
import 'package:lovia/features/discover/presentation/pages/search_page.dart';
import 'package:lovia/features/premium/presentation/bindings/premium_binding.dart';
import 'package:lovia/features/premium/presentation/pages/premium_page.dart';
import 'package:lovia/features/premium/presentation/pages/top_up_page.dart';
import 'package:lovia/features/profile/presentation/pages/language_page.dart';
import 'package:lovia/features/shell/presentation/bindings/shell_binding.dart';
import 'package:lovia/features/shell/presentation/pages/shell_page.dart';
import 'package:lovia/features/wallet/presentation/pages/daily_task_page.dart';

abstract final class AppPages {
  static final List<GetPage<dynamic>> pages = [
    GetPage<void>(name: AppRoutes.splash, page: () => const SplashPage()),
    GetPage<void>(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
    ),
    GetPage<void>(
      name: AppRoutes.welcome,
      page: () => const WelcomePage(),
    ),
    GetPage<void>(name: AppRoutes.login, page: () => const LoginPage()),
    GetPage<void>(name: AppRoutes.signup, page: () => const SignupPage()),
    GetPage<void>(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordPage(),
    ),
    GetPage<void>(
      name: AppRoutes.verifyOtp,
      page: () => const VerifyOtpPage(),
    ),
    GetPage<void>(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordPage(),
    ),
    GetPage<void>(
      name: AppRoutes.shell,
      page: () => const ShellPage(),
      binding: ShellBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage<void>(
      name: AppRoutes.characterDetail,
      page: () => const CharacterDetailPage(),
      binding: CharacterDetailBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage<void>(
      name: AppRoutes.chat,
      page: () => const ChatPage(),
      binding: ChatBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage<void>(
      name: AppRoutes.premium,
      page: () => const PremiumPage(),
      binding: PremiumBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage<void>(
      name: AppRoutes.search,
      page: () => const SearchPage(),
      binding: SearchBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage<void>(
      name: AppRoutes.topUp,
      page: () => const TopUpPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage<void>(
      name: AppRoutes.dailyTask,
      page: () => const DailyTaskPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage<void>(
      name: AppRoutes.language,
      page: () => const LanguagePage(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
