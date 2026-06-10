import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/features/auth/domain/entities/auth_provider.dart';
import 'package:lovia/features/auth/presentation/controllers/auth_controller.dart';

/// Presents the Lovia sign-in sheet (Google / Facebook / Guest / email) over
/// the current screen, gated behind an 18+ confirmation.
Future<void> showSignInSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.darkSurfaceHigh,
    builder: (_) => const _SignInSheet(),
  );
}

class _SignInSheet extends StatefulWidget {
  const _SignInSheet();

  @override
  State<_SignInSheet> createState() => _SignInSheetState();
}

class _SignInSheetState extends State<_SignInSheet> {
  final AuthController _auth = Get.find<AuthController>();
  bool _ageConfirmed = false;

  void _guard(VoidCallback action) {
    if (!_ageConfirmed) {
      Get.snackbar(
        'One moment',
        'Please confirm you are 18 or older first.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    action();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.sm,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // App avatar.
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: 'https://picsum.photos/seed/lovia-brand/200/200',
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.brandGradient,
                ),
                child: const Icon(Icons.favorite_rounded, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Welcome to Lovia AI', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.lg),

          _SheetButton(
            label: 'Continue with Google',
            leading: const _GoogleG(),
            onTap: () => _guard(() => _auth.signInWith(AuthProvider.google)),
          ),
          const SizedBox(height: AppSpacing.sm),
          _SheetButton(
            label: 'Continue with Facebook',
            leading: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
            onTap: () => _guard(() => _auth.signInWith(AuthProvider.facebook)),
          ),
          const SizedBox(height: AppSpacing.sm),
          _SheetButton(
            label: 'Login (Guest mode)',
            leading: const Icon(Icons.person_rounded, color: Colors.black87),
            onTap: () => _guard(_auth.continueAsGuest),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextButton(
            onPressed: () => _guard(() {
              Navigator.of(context).pop();
              Get.toNamed<void>(AppRoutes.login);
            }),
            child: const Text('Use email instead'),
          ),
          const SizedBox(height: AppSpacing.xs),
          _AgeConfirm(
            value: _ageConfirmed,
            onChanged: (v) => setState(() => _ageConfirmed = v),
          ),
          const SizedBox(height: AppSpacing.sm),
          _TermsText(theme: theme),
          // Busy overlay text.
          Obx(
            () => _auth.isBusy.value
                ? const Padding(
                    padding: EdgeInsets.only(top: AppSpacing.md),
                    child: LinearProgressIndicator(
                      color: AppColors.accentPink,
                      backgroundColor: Colors.white12,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    required this.label,
    required this.leading,
    required this.onTap,
  });

  final String label;
  final Widget leading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,
            const SizedBox(width: AppSpacing.sm),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _GoogleG extends StatelessWidget {
  const _GoogleG();

  @override
  Widget build(BuildContext context) {
    // Lightweight stand-in for the multicolor Google mark.
    return const Text(
      'G',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Color(0xFF4285F4),
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
            color: AppColors.accentPink,
            size: 22,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'I confirm that I am 18 years old.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }
}

class _TermsText extends StatelessWidget {
  const _TermsText({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final link = theme.textTheme.bodySmall?.copyWith(
      color: AppColors.accentPink,
      fontWeight: FontWeight.w700,
    );
    return Text.rich(
      TextSpan(
        style: theme.textTheme.bodySmall,
        children: [
          const TextSpan(
            text: 'By signing up, you confirm that you have read and '
                'understood ',
          ),
          TextSpan(text: 'Terms of Service', style: link),
          const TextSpan(text: ' and '),
          TextSpan(text: 'Privacy Policy', style: link),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
