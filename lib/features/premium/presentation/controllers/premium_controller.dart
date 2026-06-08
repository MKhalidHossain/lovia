import 'package:get/get.dart';
import 'package:lovia/core/constants/app_durations.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/state/view_state.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/premium/domain/entities/premium_plan.dart';
import 'package:lovia/features/premium/domain/usecases/get_plans.dart';

class PremiumController extends GetxController {
  PremiumController(this._getPlans);
  final GetPlans _getPlans;

  final Rx<ViewState<List<PremiumPlan>>> state =
      const ViewState<List<PremiumPlan>>.initial().obs;
  final RxString selectedPlanId = ''.obs;
  final RxBool isPurchasing = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    state.value = const ViewState<List<PremiumPlan>>.loading();
    final result = await _getPlans(const NoParams());
    switch (result) {
      case Success(:final value):
        state.value = ViewState<List<PremiumPlan>>.loaded(value);
        final highlighted = value.firstWhereOrNull((p) => p.highlighted);
        selectedPlanId.value = (highlighted ?? value.first).id;
      case Failed(:final failure):
        state.value = ViewState<List<PremiumPlan>>.error(failure.message);
    }
  }

  Future<bool> purchase() async {
    if (selectedPlanId.value.isEmpty) return false;
    isPurchasing.value = true;
    await Future<void>.delayed(AppDurations.mockLatency);
    isPurchasing.value = false;
    return true;
  }
}
