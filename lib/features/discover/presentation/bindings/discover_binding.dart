import 'package:get/get.dart';
import 'package:lovia/features/character/domain/repositories/character_repository.dart';
import 'package:lovia/features/character/domain/usecases/get_characters.dart';
import 'package:lovia/features/discover/presentation/controllers/discover_controller.dart';

class DiscoverBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut(() => GetCharacters(Get.find<CharacterRepository>()))
      ..lazyPut(() => DiscoverController(Get.find()));
  }
}
