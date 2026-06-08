import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/features/character/domain/entities/character.dart';

abstract interface class CharacterRepository {

  Future<Result<List<Character>, Failure>> getCharacters();

  Future<Result<Character, Failure>> getCharacterById(String id);

  Future<Result<List<Character>, Failure>> getMyCharacters();

  Future<Result<Character, Failure>> createCharacter(Character character);
}
