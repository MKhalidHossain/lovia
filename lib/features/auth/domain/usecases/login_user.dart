import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/auth/domain/entities/user.dart';
import 'package:lovia/features/auth/domain/repositories/auth_repository.dart';

class LoginParams {
  const LoginParams({required this.email, required this.password});
  final String email;
  final String password;
}

class LoginUser implements UseCase<User, LoginParams> {
  const LoginUser(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<User, Failure>> call(LoginParams params) {
    return _repository.login(email: params.email, password: params.password);
  }
}
