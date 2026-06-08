import 'package:get/get.dart';
import 'package:lovia/features/character/domain/repositories/character_repository.dart';
import 'package:lovia/features/character/domain/usecases/create_character.dart';
import 'package:lovia/features/character/presentation/controllers/create_character_controller.dart';

class CreateCharacterBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut(() => CreateCharacter(Get.find<CharacterRepository>()))
      ..lazyPut(() => CreateCharacterController(Get.find()));
  }
}
