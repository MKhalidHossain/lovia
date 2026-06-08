import 'package:get/get.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:lovia/features/character/domain/usecases/get_characters.dart';

class CharacterSearchController extends GetxController {
  CharacterSearchController(this._getCharacters);
  final GetCharacters _getCharacters;

  final RxString query = ''.obs;
  final RxList<Character> results = <Character>[].obs;
  final RxBool isLoading = true.obs;

  List<Character> _all = [];

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final result = await _getCharacters(const NoParams());
    if (result case Success(:final value)) {
      _all = value;
      results.assignAll(value);
    }
    isLoading.value = false;
  }

  void search(String q) {
    query.value = q;
    final lower = q.trim().toLowerCase();
    if (lower.isEmpty) {
      results.assignAll(_all);
      return;
    }
    results.assignAll(
      _all.where((c) {
        return c.name.toLowerCase().contains(lower) ||
            c.category.toLowerCase().contains(lower) ||
            c.bio.toLowerCase().contains(lower) ||
            c.traits.any((t) => t.toLowerCase().contains(lower));
      }).toList(),
    );
  }
}
