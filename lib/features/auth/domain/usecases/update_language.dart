import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/auth/domain/entities/user.dart';
import 'package:lovia/features/auth/domain/repositories/auth_repository.dart';

class UpdateLanguage implements UseCase<User, String> {
  const UpdateLanguage(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<User, Failure>> call(String params) {
    return _repository.updateLanguage(params);
  }
}
