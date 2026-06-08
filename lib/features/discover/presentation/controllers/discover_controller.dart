import 'package:get/get.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/state/view_state.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:lovia/features/character/domain/usecases/get_characters.dart';

class DiscoverController extends GetxController {
  DiscoverController(this._getCharacters);
  final GetCharacters _getCharacters;

  static const String allCategories = 'All';

  final Rx<ViewState<List<Character>>> state =
      const ViewState<List<Character>>.initial().obs;
  final RxString selectedCategory = allCategories.obs;
  final RxnString genderFilter = RxnString();
  final RxnString ageFilter = RxnString();

  List<Character> _all = [];

  bool _matchesAge(int age) {
    return switch (ageFilter.value) {
      '18-25' => age >= 18 && age <= 25,
      '25-35' => age > 25 && age <= 35,
      '>35' => age > 35,
      _ => true,
    };
  }

  void applyFilters({String? gender, String? age}) {
    genderFilter.value = gender;
    ageFilter.value = age;
    if (state.value is ViewLoaded<List<Character>>) state.refresh();
  }

  void resetFilters() {
    genderFilter.value = null;
    ageFilter.value = null;
    selectedCategory.value = allCategories;
    if (state.value is ViewLoaded<List<Character>>) state.refresh();
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  List<String> get categories {
    final set = {allCategories, ..._all.map((c) => c.category)};
    return set.toList();
  }

  List<Character> get featured => _all.take(5).toList();

  List<Character> get visible {
    return _all.where((c) {
      final byCategory = selectedCategory.value == allCategories ||
          c.category == selectedCategory.value;
      final byGender =
          genderFilter.value == null || c.gender == genderFilter.value;
      return byCategory && byGender && _matchesAge(c.age);
    }).toList();
  }

  bool get hasActiveFilters =>
      genderFilter.value != null || ageFilter.value != null;

  Future<void> load() async {
    state.value = const ViewState<List<Character>>.loading();
    final result = await _getCharacters(const NoParams());
    switch (result) {
      case Success(:final value):
        _all = value;
        state.value = ViewState<List<Character>>.loaded(value);
      case Failed(:final failure):
        state.value = ViewState<List<Character>>.error(failure.message);
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;

    if (state.value is ViewLoaded<List<Character>>) {
      state.refresh();
    }
  }
}
