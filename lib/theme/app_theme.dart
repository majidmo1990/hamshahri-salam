import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF0C447C);
  static const Color lightBlue = Color(0xFF85B7EB);
  static const Color skyBlue = Color(0xFFE6F1FB);
  static const Color darkBg = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF111111);
  static const Color darkBorder = Color(0xFF2A2A2A);
  static const Color lightBg = Color(0xFFFAF7F2);
  static const Color lightBgSecondary = Color(0xFFF3EEE4);
  static const Color lightSurface = Color(0xFFF7F7F7);
}

class AppTheme {
  static const String fontFamily = 'Vazirmatn';

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      primaryColor: AppColors.primaryBlue,
      fontFamily: fontFamily,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        secondary: AppColors.lightBlue,
        surface: AppColors.lightSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBg,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      primaryColor: AppColors.primaryBlue,
      fontFamily: fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryBlue,
        secondary: AppColors.lightBlue,
        surface: AppColors.darkSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBg,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
