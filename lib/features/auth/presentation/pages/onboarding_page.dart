import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/widgets/app_scaffold.dart';
import 'package:lovia/core/widgets/ghost_button.dart';
import 'package:lovia/core/widgets/gradient_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pages = PageController();
  int _index = 0;

  static const List<_Slide> _slides = [
    _Slide(
      icon: Icons.auto_awesome_rounded,
      title: 'Meet your companions',
      body: 'Browse characters crafted for cozy chats, bold adventures, '
          'and everything in between.',
    ),
    _Slide(
      icon: Icons.chat_bubble_rounded,
      title: 'Chat that feels alive',
      body: 'Warm, expressive conversations with characters that remember '
          'your vibe.',
    ),
    _Slide(
      icon: Icons.brush_rounded,
      title: 'Create your own',
      body: 'Design a companion — name, personality, backstory, tone — in a '
          'few taps.',
    ),
  ];

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _goToLogin() => Get.toNamed<void>(AppRoutes.login);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLast = _index == _slides.length - 1;
    return AppScaffold(
      padding: const EdgeInsets.all(AppSpacing.lg),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: _goToLogin, child: const Text('Skip')),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pages,
              itemCount: _slides.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) => _slides[i],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slides.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == _index ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == _index
                      ? theme.colorScheme.primary
                      : theme.dividerColor,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GradientButton(
            label: isLast ? 'Get started' : 'Next',
            onPressed: () {
              if (isLast) {
                _goToLogin();
              } else {
                _pages.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          GhostButton(label: 'I already have an account', onPressed: _goToLogin),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 96, color: theme.colorScheme.primary),
          const SizedBox(height: AppSpacing.xl),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.displayMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(body, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
