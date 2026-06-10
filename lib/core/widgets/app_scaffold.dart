import 'package:flutter/material.dart';
import 'package:lovia/core/theme/app_colors.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.padding,
    super.key,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          const Positioned.fill(child: AppBackdrop()),
          SafeArea(
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}

/// Near-black base with a deep magenta/maroon radial glow concentrated
/// top-left (`#5C0F2E → #2A0814`), fading to the base toward the bottom.
class AppBackdrop extends StatelessWidget {
  const AppBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.6, -0.95),
            radius: 1.3,
            colors: [
              AppColors.glowMagenta,
              AppColors.glowMaroon,
              AppColors.darkBase,
            ],
            stops: [0.0, 0.4, 0.85],
          ),
        ),
      ),
    );
  }
}
