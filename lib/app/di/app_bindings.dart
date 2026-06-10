import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lovia/core/network/dio_client.dart';
import 'package:lovia/core/theme/theme_controller.dart';
import 'package:lovia/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:lovia/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lovia/features/auth/data/datasources/auth_social_data_source.dart';
import 'package:lovia/features/auth/data/repositories/auth_repository_impl.dart';
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
import 'package:lovia/features/character/data/datasources/character_local_data_source.dart';
import 'package:lovia/features/character/data/repositories/character_repository_impl.dart';
import 'package:lovia/features/character/domain/repositories/character_repository.dart';
import 'package:lovia/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:lovia/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:lovia/features/chat/domain/repositories/chat_repository.dart';
import 'package:lovia/features/premium/data/repositories/premium_repository_impl.dart';
import 'package:lovia/features/premium/domain/repositories/premium_repository.dart';
import 'package:lovia/features/wallet/data/datasources/wallet_local_data_source.dart';
import 'package:lovia/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:lovia/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:lovia/features/wallet/domain/usecases/add_coins.dart';
import 'package:lovia/features/wallet/domain/usecases/claim_daily_reward.dart';
import 'package:lovia/features/wallet/domain/usecases/get_wallet.dart';
import 'package:lovia/features/wallet/presentation/controllers/wallet_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    final box = GetStorage();
    const secure = FlutterSecureStorage();

    const authLocal = AuthLocalDataSourceImpl(secure);
    final dioClient = DioClient(
      tokenProvider: authLocal.readToken,
      refreshTokenProvider: authLocal.readRefreshToken,
      onTokensRefreshed: (access, refresh) =>
          authLocal.updateTokens(accessToken: access, refreshToken: refresh),
      onSessionExpired: () async {
        await authLocal.clear();
        if (Get.isRegistered<AuthController>()) {
          await Get.find<AuthController>().handleSessionExpired();
        }
      },
    );
    final authRemote = AuthRemoteDataSourceImpl(dioClient.dio);
    final authRepo = AuthRepositoryImpl(
      remote: authRemote,
      local: authLocal,
      social: const AuthSocialDataSourceImpl(),
    );
    final walletRepo = WalletRepositoryImpl(WalletLocalDataSourceImpl(box));

    Get

      ..put<GetStorage>(box, permanent: true)
      ..put<FlutterSecureStorage>(secure, permanent: true)
      ..put<AuthLocalDataSource>(authLocal, permanent: true)
      ..put<DioClient>(dioClient, permanent: true)
      ..put<AuthRemoteDataSource>(authRemote, permanent: true)
      ..put<AuthRepository>(authRepo, permanent: true)

      ..put<AuthController>(
        AuthController(
          checkAuthStatus: CheckAuthStatus(authRepo),
          loginUser: LoginUser(authRepo),
          registerUser: RegisterUser(authRepo),
          logoutUser: LogoutUser(authRepo),
          getCurrentUser: GetCurrentUser(authRepo),
          requestPasswordReset: RequestPasswordReset(authRepo),
          verifyOtp: VerifyOtp(authRepo),
          resetPassword: ResetPassword(authRepo),
          signInWithProvider: SignInWithProvider(authRepo),
          signInAsGuest: SignInAsGuest(authRepo),
          updateLanguage: UpdateLanguage(authRepo),
        ),
        permanent: true,
      )

      ..put<CharacterRepository>(
        CharacterRepositoryImpl(CharacterLocalDataSourceImpl(box)),
        permanent: true,
      )
      ..put<ChatRepository>(
        ChatRepositoryImpl(ChatLocalDataSourceImpl(box)),
        permanent: true,
      )
      ..put<WalletRepository>(walletRepo, permanent: true)
      ..put<WalletController>(
        WalletController(
          getWallet: GetWallet(walletRepo),
          claimDailyReward: ClaimDailyReward(walletRepo),
          addCoins: AddCoins(walletRepo),
        ),
        permanent: true,
      )
      ..put<PremiumRepository>(const PremiumRepositoryImpl(), permanent: true)

      ..put<ThemeController>(ThemeController(box), permanent: true);
  }
}
