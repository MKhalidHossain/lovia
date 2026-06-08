import 'package:flutter_test/flutter_test.dart';
import 'package:lovia/core/error/exceptions.dart';
import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/features/character/data/datasources/character_local_data_source.dart';
import 'package:lovia/features/character/data/models/character_model.dart';
import 'package:lovia/features/character/data/repositories/character_repository_impl.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:mocktail/mocktail.dart';

class MockCharacterLocal extends Mock implements CharacterLocalDataSource {}

void main() {
  late MockCharacterLocal local;
  late CharacterRepositoryImpl repo;

  const model = CharacterModel(
    id: 'c1',
    name: 'Aria',
    bio: 'Cozy night owl',
    category: 'Cozy',
    traits: ['Warm'],
    age: 24,
    backstory: 'Runs a bookshop',
    tone: 'Gentle',
    greeting: 'Hi',
    accent: 0,
  );

  setUp(() {
    local = MockCharacterLocal();
    repo = CharacterRepositoryImpl(local);
  });

  test('getCharacters maps DTOs to entities', () async {
    when(() => local.fetchAll()).thenAnswer((_) async => [model]);

    final result = await repo.getCharacters();

    final list = (result as Success<List<Character>, Failure>).value;
    expect(list, hasLength(1));
    expect(list.first.name, 'Aria');
    expect(list.first.age, 24);
  });

  test('getCharacterById returns the entity when found', () async {
    when(() => local.fetchById('c1')).thenAnswer((_) async => model);
    final result = await repo.getCharacterById('c1');
    expect((result as Success<Character, Failure>).value.id, 'c1');
  });

  test('getCharacterById maps a CacheException to CacheFailure', () async {
    when(() => local.fetchById(any())).thenThrow(const CacheException());
    final result = await repo.getCharacterById('missing');
    expect((result as Failed).failure, isA<CacheFailure>());
  });
}
