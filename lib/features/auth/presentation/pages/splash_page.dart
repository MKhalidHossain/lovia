import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/widgets/app_scaffold.dart';
import 'package:lovia/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lovia/features/auth/presentation/controllers/auth_status.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _decide());
  }

  Future<void> _decide() async {
    final auth = Get.find<AuthController>();
    await auth.bootstrap();
    if (!mounted) return;
    final next = auth.status.value is Authenticated
        ? AppRoutes.shell
        : AppRoutes.welcome;
    await Get.offAllNamed<void>(next);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.brandGradient,
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Lovia', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Your AI companions, reimagined',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            const CircularProgressIndicator(color: AppColors.rose),
          ],
        ),
      ),
    );
  }
}
