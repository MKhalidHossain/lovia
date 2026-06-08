import 'package:lovia/core/error/exceptions.dart';
import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/features/character/data/datasources/character_local_data_source.dart';
import 'package:lovia/features/character/data/models/character_model.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:lovia/features/character/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  const CharacterRepositoryImpl(this._local);
  final CharacterLocalDataSource _local;

  @override
  Future<Result<List<Character>, Failure>> getCharacters() {
    return _guard(() async {
      final models = await _local.fetchAll();
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Result<List<Character>, Failure>> getMyCharacters() {
    return _guard(() async {
      final models = await _local.fetchMine();
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Result<Character, Failure>> getCharacterById(String id) {
    return _guard(() async => (await _local.fetchById(id)).toEntity());
  }

  @override
  Future<Result<Character, Failure>> createCharacter(Character character) {
    return _guard(() async {
      final saved = await _local.create(CharacterModel.fromEntity(character));
      return saved.toEntity();
    });
  }

  Future<Result<T, Failure>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on CacheException catch (e) {
      return Failed(CacheFailure(e.message));
    } on Object catch (e) {
      return Failed(UnknownFailure('Unexpected error: $e'));
    }
  }
}
