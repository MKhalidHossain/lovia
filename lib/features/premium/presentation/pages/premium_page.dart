import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/widgets/app_scaffold.dart';
import 'package:lovia/core/widgets/gradient_button.dart';
import 'package:lovia/core/widgets/view_state_view.dart';
import 'package:lovia/features/premium/domain/entities/premium_plan.dart';
import 'package:lovia/features/premium/presentation/controllers/premium_controller.dart';

class PremiumPage extends GetView<PremiumController> {
  const PremiumPage({super.key});

  Future<void> _purchase() async {
    final ok = await controller.purchase();
    if (ok) {
      await Get.bottomSheet<void>(
        const _SuccessSheet(),
        backgroundColor: Get.theme.colorScheme.surface,
        isScrollControlled: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Lovia Premium')),
      body: Obx(
        () => ViewStateView<List<PremiumPlan>>(
          state: controller.state.value,
          onRetry: controller.load,
          builder: (context, plans) => _Body(plans: plans, onPurchase: _purchase),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.plans, required this.onPurchase});
  final List<PremiumPlan> plans;
  final Future<void> Function() onPurchase;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PremiumController>();
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(
                'Unlock the full Lovia experience',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              ...plans.map(
                (plan) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Obx(
                    () => _PlanCard(
                      plan: plan,
                      selected: controller.selectedPlanId.value == plan.id,
                      onTap: () => controller.selectedPlanId.value = plan.id,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Get.snackbar(
                  'Restore purchases',
                  'No previous purchases found (demo).',
                ),
                child: const Text('Restore purchases'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Obx(
            () => GradientButton(
              label: 'Continue',
              isLoading: controller.isPurchasing.value,
              onPressed: onPurchase,
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });
  final PremiumPlan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(
            color: selected ? AppColors.violet : theme.dividerColor,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(plan.title, style: theme.textTheme.titleLarge),
                ),
                if (plan.highlighted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                    child: const Text(
                      'Best value',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(plan.price, style: theme.textTheme.displayMedium),
                const SizedBox(width: AppSpacing.xs),
                Text(plan.period, style: theme.textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ...plan.perks.map(
              (perk) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        size: 18, color: AppColors.success),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(child: Text(perk, style: theme.textTheme.bodyMedium)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessSheet extends StatelessWidget {
  const _SuccessSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.celebration_rounded,
              size: 64, color: AppColors.amber),
          const SizedBox(height: AppSpacing.md),
          Text("You're all set!", style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'This is a demo purchase — no payment was taken.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          GradientButton(label: 'Done', onPressed: () => Get.back<void>()),
        ],
      ),
    );
  }
}
