import 'package:get/get.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/state/view_state.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:lovia/features/character/domain/usecases/get_character_by_id.dart';

class CharacterDetailController extends GetxController {
  CharacterDetailController(this._getCharacterById);
  final GetCharacterById _getCharacterById;

  final Rx<ViewState<Character>> state =
      const ViewState<Character>.initial().obs;

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments as String?;
    if (id != null) {
      load(id);
    } else {
      state.value = const ViewState<Character>.error('No character selected.');
    }
  }

  Future<void> load(String id) async {
    state.value = const ViewState<Character>.loading();
    final result = await _getCharacterById(id);
    state.value = switch (result) {
      Success(:final value) => ViewState<Character>.loaded(value),
      Failed(:final failure) => ViewState<Character>.error(failure.message),
    };
  }
}
