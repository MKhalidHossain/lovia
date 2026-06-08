import 'package:get/get.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/state/view_state.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:lovia/features/character/domain/usecases/get_characters.dart';

class HomeController extends GetxController {
  HomeController(this._getCharacters);
  final GetCharacters _getCharacters;

  final Rx<ViewState<List<Character>>> state =
      const ViewState<List<Character>>.initial().obs;
  final RxInt index = 0.obs;
  final RxList<String> liked = <String>[].obs;

  List<Character> _deck = [];

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Character? get current => index.value < _deck.length ? _deck[index.value] : null;

  Character? get peek =>
      index.value + 1 < _deck.length ? _deck[index.value + 1] : null;

  bool get isExhausted => index.value >= _deck.length;

  Future<void> load() async {
    state.value = const ViewState<List<Character>>.loading();
    index.value = 0;
    final result = await _getCharacters(const NoParams());
    switch (result) {
      case Success(:final value):
        _deck = value;
        state.value = ViewState<List<Character>>.loaded(value);
      case Failed(:final failure):
        state.value = ViewState<List<Character>>.error(failure.message);
    }
  }

  void pass() => _advance();

  void like() {
    final c = current;
    if (c != null && !liked.contains(c.id)) liked.add(c.id);
    _advance();
  }

  void _advance() {
    if (index.value < _deck.length) index.value++;
  }

  void restart() {
    index.value = 0;
  }
}
