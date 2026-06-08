import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/premium/domain/entities/premium_plan.dart';
import 'package:lovia/features/premium/domain/repositories/premium_repository.dart';

class GetPlans implements UseCase<List<PremiumPlan>, NoParams> {
  const GetPlans(this._repository);
  final PremiumRepository _repository;

  @override
  Future<Result<List<PremiumPlan>, Failure>> call(NoParams params) {
    return _repository.getPlans();
  }
}
