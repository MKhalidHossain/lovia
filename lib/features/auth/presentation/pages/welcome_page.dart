import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/features/auth/domain/entities/auth_provider.dart';
import 'package:lovia/features/auth/presentation/controllers/auth_controller.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final AuthController _auth = Get.find<AuthController>();
  bool _ageConfirmed = false;

  void _guard(VoidCallback action) {
    if (!_ageConfirmed) {
      Get.snackbar('One moment', 'Please confirm you are 18 or older first.');
      return;
    }
    action();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _AvatarBackdrop(),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xE015101C), Color(0xFF15101C)],
                stops: [0.2, 0.6, 1],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                Container(
                  margin: const EdgeInsets.all(AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppRadii.xl),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.brandGradient,
                        ),
                        child: const Icon(Icons.favorite_rounded,
                            color: Colors.white, size: 36),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Welcome to Lovia',
                          style: theme.textTheme.titleLarge),
                      const SizedBox(height: AppSpacing.lg),
                      _SocialButton(
                        label: 'Continue with Google',
                        icon: Icons.g_mobiledata_rounded,
                        onTap: () =>
                            _guard(() => _auth.signInWith(AuthProvider.google)),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _SocialButton(
                        label: 'Continue with Apple',
                        icon: Icons.apple_rounded,
                        onTap: () =>
                            _guard(() => _auth.signInWith(AuthProvider.apple)),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _SocialButton(
                        label: 'Continue with Facebook',
                        icon: Icons.facebook_rounded,
                        onTap: () => _guard(
                          () => _auth.signInWith(AuthProvider.facebook),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _SocialButton(
                        label: 'Login (Guest mode)',
                        icon: Icons.person_outline_rounded,
                        onTap: () => _guard(_auth.continueAsGuest),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextButton(
                        onPressed: () => _guard(
                          () => Get.toNamed<void>(AppRoutes.login),
                        ),
                        child: const Text('Use email instead'),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      _AgeConfirm(
                        value: _ageConfirmed,
                        onChanged: (v) => setState(() => _ageConfirmed = v),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'By continuing, you confirm that you have read and '
                        'understood the Terms of Service and Privacy Policy.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Obx(
              () => _auth.isBusy.value
                  ? const ColoredBox(
                      color: Color(0x88000000),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonalIcon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
        ),
      ),
    );
  }
}

class _AgeConfirm extends StatelessWidget {
  const _AgeConfirm({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            value ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: AppColors.rose,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text('I confirm that I am 18 years old.',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _AvatarBackdrop extends StatelessWidget {
  const _AvatarBackdrop();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3A1B4A), Color(0xFF15101C)],
        ),
      ),
      child: Stack(
        children: [
          for (final spec in const [
            [0.12, 0.16, 64.0, 1],
            [0.78, 0.12, 80.0, 2],
            [0.7, 0.34, 60.0, 5],
            [0.2, 0.42, 52.0, 8],
          ])
            Align(
              alignment: Alignment(
                (spec[0] as double) * 2 - 1,
                (spec[1] as double) * 2 - 1,
              ),
              child: Container(
                width: spec[2] as double,
                height: spec[2] as double,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.accentGradient(spec[3] as int),
                  border: Border.all(color: Colors.white24, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
