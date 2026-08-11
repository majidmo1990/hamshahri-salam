import 'package:flutter/material.dart';

class AppColors {
  // پالت طلایی برند
  static const Color goldPrimary = Color(0xFFD6AE59);
  static const Color goldLight = Color(0xFFE3BD68);
  static const Color goldHighlight = Color(0xFFF3D27C);
  static const Color goldExtraLight = Color(0xFFF8DFA0);
  static const Color goldDark = Color(0xFFAB8239);
  static const Color goldShadow = Color(0xFF98702F);
  static const Color goldDeepShadow = Color(0xFF825D24);

  // پس‌زمینه تیره - مشکی غنی و کمی براق (نه مات صرف)
  static const Color darkBg = Color(0xFF0D0D0D);
  static const Color darkBgSecondary = Color(0xFF1C1712);
  static const Color darkSurface = Color(0xFF221C14);
  static const Color darkBorder = Color(0xFF4A3D26);

  // پس‌زمینه روشن (کرم گرم، هماهنگ با طلایی)
  static const Color lightBg = Color(0xFFFBF6EC);
  static const Color lightBgSecondary = Color(0xFFF2E7D0);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE3D5B0);

  // نگهداری نام‌های قبلی برای سازگاری با کدهای موجود
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
          shadowColor: AppColors.goldHighlight.withValues(alpha: 0.5),
          elevation: 6,
        ),
      ),
    );
  }
}
