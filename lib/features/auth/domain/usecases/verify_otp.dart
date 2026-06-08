import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpParams {
  const VerifyOtpParams({required this.email, required this.otp});
  final String email;
  final String otp;
}

class VerifyOtp implements UseCase<Unit, VerifyOtpParams> {
  const VerifyOtp(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<Unit, Failure>> call(VerifyOtpParams params) {
    return _repository.verifyOtp(email: params.email, otp: params.otp);
  }
}
