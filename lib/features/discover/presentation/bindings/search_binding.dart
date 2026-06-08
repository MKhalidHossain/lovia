import 'package:get/get.dart';
import 'package:lovia/features/character/domain/repositories/character_repository.dart';
import 'package:lovia/features/character/domain/usecases/get_characters.dart';
import 'package:lovia/features/discover/presentation/controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<GetCharacters>(
        () => GetCharacters(Get.find<CharacterRepository>()),
        fenix: true,
      )
      ..lazyPut(() => CharacterSearchController(Get.find()));
  }
}
