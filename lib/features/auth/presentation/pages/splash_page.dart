import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/theme/app_spacing.dart';
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
    // Brief brand moment.
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    final next = auth.status.value is Authenticated
        ? AppRoutes.shell
        : AppRoutes.onboarding;
    await Get.offAllNamed<void>(next);
  }

  String _hero(int seed) => 'https://picsum.photos/seed/lovia$seed/800/1400';
  String _avatar(int seed) => 'https://picsum.photos/seed/lovia$seed/200/200';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.darkBase,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: _hero(7),
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) =>
                const ColoredBox(color: AppColors.glowMagenta),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x22000000), Color(0xAA0D0407), Color(0xFF0D0407)],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),
          // Orbiting companion avatars.
          for (final spec in const [
            [0.78, 0.14, 64.0, 21],
            [0.12, 0.28, 80.0, 22],
            [0.82, 0.46, 72.0, 23],
          ])
            Align(
              alignment: Alignment(
                (spec[0] as double) * 2 - 1,
                (spec[1] as double) * 2 - 1,
              ),
              child: _OrbitAvatar(
                url: _avatar(spec[3] as int),
                size: spec[2] as double,
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Lovia AI', style: theme.textTheme.displayLarge),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Find Your Perfect Match',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.darkTextMedium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // Thin progress bar.
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    child: const LinearProgressIndicator(
                      minHeight: 4,
                      color: AppColors.accentPink,
                      backgroundColor: Colors.white12,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrbitAvatar extends StatelessWidget {
  const _OrbitAvatar({required this.url, required this.size});
  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) =>
              const ColoredBox(color: AppColors.darkSurfaceHigh),
        ),
      ),
    );
  }
}
