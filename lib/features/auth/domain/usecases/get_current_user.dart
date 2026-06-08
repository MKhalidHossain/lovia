import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/auth/domain/entities/user.dart';
import 'package:lovia/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<User, NoParams> {
  const GetCurrentUser(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<User, Failure>> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
