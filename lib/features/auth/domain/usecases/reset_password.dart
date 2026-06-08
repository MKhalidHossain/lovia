import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordParams {
  const ResetPasswordParams({
    required this.email,
    required this.otp,
    required this.newPassword,
  });
  final String email;
  final String otp;
  final String newPassword;
}

class ResetPassword implements UseCase<Unit, ResetPasswordParams> {
  const ResetPassword(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<Unit, Failure>> call(ResetPasswordParams params) {
    return _repository.resetPassword(
      email: params.email,
      otp: params.otp,
      newPassword: params.newPassword,
    );
  }
}
