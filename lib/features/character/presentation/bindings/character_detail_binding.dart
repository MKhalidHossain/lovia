import 'package:get/get.dart';
import 'package:lovia/features/character/domain/repositories/character_repository.dart';
import 'package:lovia/features/character/domain/usecases/get_character_by_id.dart';
import 'package:lovia/features/character/presentation/controllers/character_detail_controller.dart';

class CharacterDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut(() => GetCharacterById(Get.find<CharacterRepository>()))
      ..lazyPut(() => CharacterDetailController(Get.find()));
  }
}
