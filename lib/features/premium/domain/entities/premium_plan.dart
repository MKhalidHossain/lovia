import 'package:freezed_annotation/freezed_annotation.dart';

part 'premium_plan.freezed.dart';

@freezed
class PremiumPlan with _$PremiumPlan {
  const factory PremiumPlan({
    required String id,
    required String title,
    required String price,
    required String period,
    required List<String> perks,
    @Default(false) bool highlighted,
  }) = _PremiumPlan;
}
