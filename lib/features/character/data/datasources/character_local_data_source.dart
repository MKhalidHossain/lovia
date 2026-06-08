import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:lovia/core/constants/app_durations.dart';
import 'package:lovia/core/constants/storage_keys.dart';
import 'package:lovia/core/error/exceptions.dart';
import 'package:lovia/features/character/data/datasources/character_sample_data.dart';
import 'package:lovia/features/character/data/models/character_model.dart';

abstract interface class CharacterLocalDataSource {
  Future<List<CharacterModel>> fetchAll();
  Future<List<CharacterModel>> fetchMine();
  Future<CharacterModel> fetchById(String id);
  Future<CharacterModel> create(CharacterModel character);
}

class CharacterLocalDataSourceImpl implements CharacterLocalDataSource {
  CharacterLocalDataSourceImpl(this._box);
  final GetStorage _box;

  @override
  Future<List<CharacterModel>> fetchAll() async {
    await Future<void>.delayed(AppDurations.mockLatency);
    return [...CharacterSampleData.all, ..._readMine()];
  }

  @override
  Future<List<CharacterModel>> fetchMine() async {
    await Future<void>.delayed(AppDurations.mockLatency);
    return _readMine();
  }

  @override
  Future<CharacterModel> fetchById(String id) async {
    await Future<void>.delayed(AppDurations.fast);
    final all = [...CharacterSampleData.all, ..._readMine()];
    final match = all.where((c) => c.id == id).toList();
    if (match.isEmpty) {
      throw const CacheException('Character not found');
    }
    return match.first;
  }

  @override
  Future<CharacterModel> create(CharacterModel character) async {
    await Future<void>.delayed(AppDurations.fast);
    final mine = _readMine()..add(character);
    await _writeMine(mine);
    return character;
  }

  List<CharacterModel> _readMine() {
    final raw = _box.read<String>(StorageKeys.myCharacters);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FormatException {
      return [];
    }
  }

  Future<void> _writeMine(List<CharacterModel> characters) async {
    final raw = jsonEncode(characters.map((c) => c.toJson()).toList());
    await _box.write(StorageKeys.myCharacters, raw);
  }
}
