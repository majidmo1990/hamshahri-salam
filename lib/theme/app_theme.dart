import 'package:flutter/material.dart';

class AppColors {
  static const Color goldPrimary = Color(0xFFC9A227);
  static const Color goldLight = Color(0xFFE0B94A);
  static const Color goldHighlight = Color(0xFFF5D680);
  static const Color goldExtraLight = Color(0xFFFAE7B0);
  static const Color goldDark = Color(0xFF9C7D1E);
  static const Color goldShadow = Color(0xFF7C6318);
  static const Color goldDeepShadow = Color(0xFF5E4A10);

  static const Color darkBg = Color(0xFF0B0B0B);
  static const Color darkBgSecondary = Color(0xFF1A150E);
  static const Color darkSurface = Color(0xFF231D12);
  static const Color darkBorder = Color(0xFF5A4A22);
  static const Color darkGoldBorder = Color(0x59E0B94A);

  static const Color lightBg = Color(0xFFFBF6EC);
  static const Color lightBgSecondary = Color(0xFFF2E7D0);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE3D5B0);

  static const Color primaryBlue = goldLight;
  static const Color lightBlue = goldHighlight;
  static const Color skyBlue = Color(0xFFF6EDD9);
}

class AppTheme {
  static const String fontFamily = 'Vazirmatn';

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      primaryColor: AppColors.goldPrimary,
      fontFamily: fontFamily,
      colorScheme: const ColorScheme.light(
        primary: AppColors.goldPrimary,
        secondary: AppColors.goldDark,
        surface: AppColors.lightSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBg,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldPrimary,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      primaryColor: AppColors.goldLight,
      fontFamily: fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.goldLight,
        secondary: AppColors.goldHighlight,
        surface: AppColors.darkSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBg,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldLight,
          foregroundColor: Colors.black,
          shadowColor: AppColors.goldHighlight.withValues(alpha: 0.6),
          elevation: 8,
        ),
      ),
    );
  }
}
