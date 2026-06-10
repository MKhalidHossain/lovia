import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/widgets/gradient_button.dart';
import 'package:lovia/features/auth/presentation/pages/sign_in_sheet.dart';

/// Welcome / onboarding hero — a full-bleed companion image with chat-bubble
/// teasers and an avatar carousel. "Get Started" opens the sign-in sheet.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const List<int> _carouselSeeds = [11, 12, 13, 14, 15];
  int _selected = 2;

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
          // Hero image.
          CachedNetworkImage(
            imageUrl: _hero(_carouselSeeds[_selected]),
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) =>
                const ColoredBox(color: AppColors.glowMagenta),
          ),
          // Readability gradient.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x33000000), Color(0xCC0D0407), Color(0xFF0D0407)],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Welcome back!\nWe missed you',
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: AppColors.rose.withValues(alpha: 0.9),
                      fontSize: 36,
                    ),
                  ),
                  const Spacer(),
                  const _ChatTeasers(),
                  const SizedBox(height: AppSpacing.lg),
                  _Carousel(
                    seeds: _carouselSeeds,
                    selected: _selected,
                    avatar: _avatar,
                    onSelect: (i) => setState(() => _selected = i),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GradientButton(
                    label: 'Get Started',
                    onPressed: () => showSignInSheet(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatTeasers extends StatelessWidget {
  const _ChatTeasers();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _Bubble('I miss you already…'),
        SizedBox(height: AppSpacing.xs),
        _Bubble("I'm always just one message away, love"),
        SizedBox(height: AppSpacing.xs),
        _Bubble('…'),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 260),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadii.xl),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}

class _Carousel extends StatelessWidget {
  const _Carousel({
    required this.seeds,
    required this.selected,
    required this.avatar,
    required this.onSelect,
  });

  final List<int> seeds;
  final int selected;
  final String Function(int) avatar;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < seeds.length; i++)
            GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: i == selected ? 68 : 52,
                height: i == selected ? 68 : 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: i == selected ? AppColors.accentPink : Colors.white24,
                    width: i == selected ? 3 : 1.5,
                  ),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: avatar(seeds[i]),
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) =>
                        const ColoredBox(color: AppColors.darkSurfaceHigh),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
