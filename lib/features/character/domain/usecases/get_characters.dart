import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:lovia/features/character/domain/repositories/character_repository.dart';

class GetCharacters implements UseCase<List<Character>, NoParams> {
  const GetCharacters(this._repository);
  final CharacterRepository _repository;

  @override
  Future<Result<List<Character>, Failure>> call(NoParams params) {
    return _repository.getCharacters();
  }
}
