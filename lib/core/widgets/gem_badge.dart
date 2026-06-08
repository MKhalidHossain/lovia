import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/features/wallet/presentation/controllers/wallet_controller.dart';

class GemBadge extends StatelessWidget {
  const GemBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = Get.find<WalletController>();
    return GestureDetector(
      onTap: () => Get.toNamed<void>(AppRoutes.topUp),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadii.pill),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.public_rounded, color: Color(0xFF5FB7FF), size: 18),
            const SizedBox(width: 6),
            Obx(
              () => Text(
                '${wallet.balance}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
