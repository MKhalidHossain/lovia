import 'package:get/get.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/state/view_state.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:lovia/features/character/domain/usecases/get_my_characters.dart';

class ProfileController extends GetxController {
  ProfileController(this._getMyCharacters);
  final GetMyCharacters _getMyCharacters;

  final Rx<ViewState<List<Character>>> myCharacters =
      const ViewState<List<Character>>.initial().obs;

  @override
  void onInit() {
    super.onInit();
    loadMine();
  }

  Future<void> loadMine() async {
    myCharacters.value = const ViewState<List<Character>>.loading();
    final result = await _getMyCharacters(const NoParams());
    myCharacters.value = switch (result) {
      Success(:final value) => ViewState<List<Character>>.loaded(value),
      Failed(:final failure) => ViewState<List<Character>>.error(failure.message),
    };
  }
}
