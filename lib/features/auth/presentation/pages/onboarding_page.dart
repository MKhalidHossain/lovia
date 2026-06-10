import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/widgets/gradient_button.dart';
import 'package:lovia/features/auth/presentation/pages/sign_in_sheet.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _page = 0;

  late final AnimationController _float;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _float.dispose();
    _pulse.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOutCubic,
      );
    } else {
      showSignInSheet(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBase,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _page = i),
            children: [
              _DiscoverScreen(floatAnim: _float),
              _ChatScreen(floatAnim: _float),
              _MatchScreen(pulseAnim: _pulse),
            ],
          ),
          // Skip
          if (_page < 2)
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.sm,
                    right: AppSpacing.lg,
                  ),
                  child: TextButton(
                    onPressed: () => showSignInSheet(context),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          // Dots + CTA
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _page ? 26 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadii.pill),
                            color: i == _page
                                ? AppColors.rose
                                : Colors.white.withValues(alpha: 0.2),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    GradientButton(
                      label: _page < 2 ? 'Continue' : 'Find My Match  ✨',
                      onPressed: _next,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Screen 1 — Discover
// ──────────────────────────────────────────────────────────────────────────────

class _DiscoverScreen extends StatelessWidget {
  const _DiscoverScreen({required this.floatAnim});
  final Animation<double> floatAnim;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const _Bg(
          colors: [Color(0xFF0D0118), Color(0xFF280A38), Color(0xFF5C0F3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        const _Orb(color: AppColors.violet, size: 280, top: -80, right: -80, opacity: 0.07),
        const _Orb(color: AppColors.rose, size: 200, bottom: 120, left: -70, opacity: 0.06),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 64),
                Center(
                  child: AnimatedBuilder(
                    animation: floatAnim,
                    builder: (_, __) => SizedBox(
                      height: 310,
                      width: 260,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 24,
                            right: 0,
                            child: Transform.rotate(
                              angle: 0.1,
                              child: _ProfileCard(
                                url: 'https://picsum.photos/seed/loviaA2/300/400',
                                name: 'Zara',
                                age: 25,
                                tag: '💃 Dancer',
                                online: false,
                                lift: floatAnim.value * 4,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Transform.rotate(
                              angle: -0.07,
                              child: _ProfileCard(
                                url: 'https://picsum.photos/seed/loviaA3/300/400',
                                name: 'Mia',
                                age: 23,
                                tag: '🎸 Music lover',
                                online: false,
                                lift: floatAnim.value * 6,
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(0, -(floatAnim.value * 9)),
                            child: _ProfileCard(
                              url: 'https://picsum.photos/seed/loviaA1/300/400',
                              name: 'Sofia',
                              age: 24,
                              tag: '✈️ Traveller',
                              online: true,
                              lift: 0,
                              featured: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const _GradTitle(
                  'Find Your\nSpark ✨',
                  gradient: AppColors.brandGradient,
                ),
                const SizedBox(height: AppSpacing.md),
                const _SubText(
                  'Real people. Real vibes.\nYour person is closer than you think.',
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Screen 2 — Chat
// ──────────────────────────────────────────────────────────────────────────────

class _ChatScreen extends StatelessWidget {
  const _ChatScreen({required this.floatAnim});
  final Animation<double> floatAnim;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const _Bg(
          colors: [Color(0xFF01101E), Color(0xFF0A2240), Color(0xFF0C4A6A)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        const _Orb(color: Color(0xFF00D4FF), size: 260, top: -60, right: -60, opacity: 0.06),
        const _Orb(color: AppColors.violet, size: 180, bottom: 100, left: -50, opacity: 0.07),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 64),
                AnimatedBuilder(
                  animation: floatAnim,
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, floatAnim.value * -7),
                    child: const _ChatPreview(),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const _GradTitle(
                  'Break the\nIce 💬',
                  gradient: LinearGradient(
                    colors: [Color(0xFF00D4FF), Color(0xFF8B5CF6)],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const _SubText(
                  "Never stare at a blank chat.\nOur AI gives you the perfect opening line.",
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatPreview extends StatelessWidget {
  const _ChatPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D4FF).withValues(alpha: 0.08),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _CircleImg(url: 'https://picsum.photos/seed/loviaC1/80/80', size: 40),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Emma, 23',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          margin: const EdgeInsets.only(right: 5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.success,
                          ),
                        ),
                        Text(
                          'Online now',
                          style: TextStyle(
                            color: AppColors.success.withValues(alpha: 0.9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
                child: const Text(
                  '98% match',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const _OutBubble('Hey Emma! You love hiking? 🏔️'),
          const SizedBox(height: 6),
          const _InBubble('Omg YES — have you done the Rockies? 😍'),
          const SizedBox(height: 6),
          const _OutBubble('Not yet — maybe we could go together? 😊'),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.violet.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadii.md),
              border: Border.all(color: AppColors.violet.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                const Text('✨', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'AI: "Which trail is your favourite?"',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Screen 3 — Match
// ──────────────────────────────────────────────────────────────────────────────

class _MatchScreen extends StatelessWidget {
  const _MatchScreen({required this.pulseAnim});
  final Animation<double> pulseAnim;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const _Bg(
          colors: [Color(0xFF180407), Color(0xFF4A0F1C), Color(0xFF8B1A3A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        const Positioned.fill(child: _Stars()),
        _Orb(color: AppColors.rose, size: 300, top: 40, left: -60, opacity: 0.08),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 64),
                Center(
                  child: AnimatedBuilder(
                    animation: pulseAnim,
                    builder: (_, __) => Transform.scale(
                      scale: 1.0 + pulseAnim.value * 0.04,
                      child: const _MatchBadge(),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _GradTitle(
                  "It's a\nMatch! ❤️",
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B9D), Color(0xFFFF3A5E)],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _SubText(
                  'Thousands found their person here.\nYour love story is waiting to be written.',
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MatchBadge extends StatelessWidget {
  const _MatchBadge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      width: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft glow rings
          Container(
            width: 210,
            height: 210,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.rose.withValues(alpha: 0.07),
            ),
          ),
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.rose.withValues(alpha: 0.09),
            ),
          ),
          // Left avatar
          Positioned(
            left: 10,
            child: _CircleImg(
              url: 'https://picsum.photos/seed/loviaM1/200/200',
              size: 110,
              border: true,
            ),
          ),
          // Right avatar
          Positioned(
            right: 10,
            child: _CircleImg(
              url: 'https://picsum.photos/seed/loviaM2/200/200',
              size: 110,
              border: true,
            ),
          ),
          // Heart overlap
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.brandGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.rose.withValues(alpha: 0.6),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Text('❤️', style: TextStyle(fontSize: 24)),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Shared sub-widgets
// ──────────────────────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.url,
    required this.name,
    required this.age,
    required this.tag,
    required this.online,
    required this.lift,
    this.featured = false,
  });

  final String url;
  final String name;
  final int age;
  final String tag;
  final bool online;
  final double lift;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: featured ? 200 : 170,
      height: featured ? 270 : 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.glowMagenta.withValues(alpha: featured ? 0.5 : 0.2),
            blurRadius: featured ? 30 : 16,
            spreadRadius: featured ? 4 : 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5C0F2E), Color(0xFF280A38)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xDD000000)],
                    stops: [0.45, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$name, $age',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: featured ? 15 : 13,
                        ),
                      ),
                      if (online) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    tag,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleImg extends StatelessWidget {
  const _CircleImg({required this.url, required this.size, this.border = false});
  final String url;
  final double size;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: border
            ? Border.all(color: AppColors.rose.withValues(alpha: 0.7), width: 2.5)
            : null,
        boxShadow: border
            ? [
                BoxShadow(
                  color: AppColors.rose.withValues(alpha: 0.25),
                  blurRadius: 14,
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) =>
              Container(color: AppColors.glowMagenta),
        ),
      ),
    );
  }
}

class _OutBubble extends StatelessWidget {
  const _OutBubble(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 230),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }
}

class _InBubble extends StatelessWidget {
  const _InBubble(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 230),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }
}

class _GradTitle extends StatelessWidget {
  const _GradTitle(this.text, {required this.gradient});
  final String text;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 42,
          fontWeight: FontWeight.w800,
          height: 1.1,
        ),
      ),
    );
  }
}

class _SubText extends StatelessWidget {
  const _SubText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.6),
        fontSize: 16,
        height: 1.65,
      ),
    );
  }
}

class _Bg extends StatelessWidget {
  const _Bg({required this.colors, required this.begin, required this.end});
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: begin, end: end),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({
    required this.color,
    required this.size,
    required this.opacity,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  final Color color;
  final double size;
  final double opacity;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
        ),
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _StarsPainter());
  }
}

class _StarsPainter extends CustomPainter {
  static const _dots = [
    [0.12, 0.08], [0.88, 0.06], [0.45, 0.13], [0.68, 0.19],
    [0.23, 0.28], [0.78, 0.32], [0.92, 0.48], [0.08, 0.52],
    [0.52, 0.10], [0.35, 0.42], [0.82, 0.22], [0.6, 0.38],
    [0.18, 0.65], [0.72, 0.55], [0.42, 0.25],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.25);
    for (final d in _dots) {
      canvas.drawCircle(Offset(size.width * d[0], size.height * d[1]), 1.8, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
