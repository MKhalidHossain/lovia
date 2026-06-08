import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/auth/domain/entities/auth_provider.dart';
import 'package:lovia/features/auth/domain/entities/user.dart';
import 'package:lovia/features/auth/domain/repositories/auth_repository.dart';

class SignInWithProvider implements UseCase<User, AuthProvider> {
  const SignInWithProvider(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<User, Failure>> call(AuthProvider params) {
    return _repository.signInWithProvider(params);
  }
}
