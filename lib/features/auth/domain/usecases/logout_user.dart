import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/auth/domain/repositories/auth_repository.dart';

class LogoutUser implements UseCase<Unit, NoParams> {
  const LogoutUser(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<Unit, Failure>> call(NoParams params) {
    return _repository.logout();
  }
}
