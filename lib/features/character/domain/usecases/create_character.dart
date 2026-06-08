import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:lovia/features/character/domain/repositories/character_repository.dart';

class CreateCharacter implements UseCase<Character, Character> {
  const CreateCharacter(this._repository);
  final CharacterRepository _repository;

  @override
  Future<Result<Character, Failure>> call(Character params) {
    return _repository.createCharacter(params);
  }
}
