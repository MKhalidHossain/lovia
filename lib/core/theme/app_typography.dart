import 'package:flutter/material.dart';

/// Rounded humanist sans (Nunito, bundled as a local asset) for the whole app.
///
/// Page titles ~28 bold, card titles ~20 bold, body ~15.
abstract final class AppTypography {
  static const String fontFamily = 'Nunito';

  static TextTheme textTheme(Color high, Color medium) {
    return TextTheme(
      displayLarge: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 40,
        height: 1.05,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ).copyWith(color: high),
      displayMedium: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        height: 1.15,
        fontWeight: FontWeight.w800,
      ).copyWith(color: high),
      headlineMedium: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        height: 1.2,
        fontWeight: FontWeight.w700,
      ).copyWith(color: high),
      titleLarge: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ).copyWith(color: high),
      titleMedium: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ).copyWith(color: high),
      bodyLarge: const TextStyle(fontFamily: fontFamily, fontSize: 15, height: 1.45)
          .copyWith(color: high),
      bodyMedium: const TextStyle(fontFamily: fontFamily, fontSize: 14, height: 1.45)
          .copyWith(color: medium),
      bodySmall: const TextStyle(fontFamily: fontFamily, fontSize: 12, height: 1.4)
          .copyWith(color: medium),
      labelLarge: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ).copyWith(color: high),
    );
  }
}
