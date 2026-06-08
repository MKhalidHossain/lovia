import 'package:flutter/material.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/theme/app_spacing.dart';

class CoinBadge extends StatelessWidget {
  const CoinBadge({
    required this.amount,
    this.icon = Icons.monetization_on_rounded,
    super.key,
  });

  final int amount;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.amber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: AppColors.amber.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.amber),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            '$amount',
            style: const TextStyle(
              color: AppColors.amber,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
