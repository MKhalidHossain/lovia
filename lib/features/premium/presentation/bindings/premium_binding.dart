import 'package:get/get.dart';
import 'package:lovia/features/premium/domain/repositories/premium_repository.dart';
import 'package:lovia/features/premium/domain/usecases/get_plans.dart';
import 'package:lovia/features/premium/presentation/controllers/premium_controller.dart';

class PremiumBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut(() => GetPlans(Get.find<PremiumRepository>()))
      ..lazyPut(() => PremiumController(Get.find()));
  }
}
