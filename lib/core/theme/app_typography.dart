import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const String _display = 'Lovia';

  static TextTheme textTheme(Color high, Color medium) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: _display,
        fontSize: 40,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: high,
      ),
      displayMedium: TextStyle(
        fontFamily: _display,
        fontSize: 32,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: high,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: high,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: high,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: high,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.45, color: high),
      bodyMedium: TextStyle(fontSize: 14, height: 1.45, color: medium),
      bodySmall: TextStyle(fontSize: 12, height: 1.4, color: medium),
      labelLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: high,
      ),
    );
  }
}
