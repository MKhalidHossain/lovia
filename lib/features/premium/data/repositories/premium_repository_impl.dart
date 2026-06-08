import 'package:lovia/core/constants/app_durations.dart';
import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/features/premium/domain/entities/premium_plan.dart';
import 'package:lovia/features/premium/domain/repositories/premium_repository.dart';

class PremiumRepositoryImpl implements PremiumRepository {
  const PremiumRepositoryImpl();

  @override
  Future<Result<List<PremiumPlan>, Failure>> getPlans() async {
    await Future<void>.delayed(AppDurations.mockLatency);
    return const Success([
      PremiumPlan(
        id: 'weekly',
        title: 'Lovia Plus',
        price: r'$4.99',
        period: 'per week',
        perks: [
          'Unlimited chats',
          'Priority replies',
          'Exclusive characters',
        ],
      ),
      PremiumPlan(
        id: 'yearly',
        title: 'Lovia Plus',
        price: r'$39.99',
        period: 'per year',
        perks: [
          'Everything in weekly',
          'Best value — save 80%',
          'Early access to new features',
        ],
        highlighted: true,
      ),
      PremiumPlan(
        id: 'diamonds',
        title: 'Diamond Pack',
        price: r'$9.99',
        period: '500 diamonds',
        perks: [
          'Unlock premium gifts',
          'Boost your favorite characters',
        ],
      ),
    ]);
  }
}
