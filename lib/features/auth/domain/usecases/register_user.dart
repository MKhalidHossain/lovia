import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/auth/domain/repositories/auth_repository.dart';

class RegisterParams {
  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });
  final String name;
  final String email;
  final String password;
}

class RegisterUser implements UseCase<Unit, RegisterParams> {
  const RegisterUser(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<Unit, Failure>> call(RegisterParams params) {
    return _repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}
