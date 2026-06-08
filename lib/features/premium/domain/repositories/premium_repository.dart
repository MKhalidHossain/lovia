import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/features/premium/domain/entities/premium_plan.dart';

// ignore: one_member_abstracts — contract kept for layering symmetry.
abstract interface class PremiumRepository {
  Future<Result<List<PremiumPlan>, Failure>> getPlans();
}
