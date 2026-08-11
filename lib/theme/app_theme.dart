import 'package:flutter/material.dart';

class AppColors {
  // پالت طلایی برند
  static const Color goldPrimary = Color(0xFFC89E4D);
  static const Color goldLight = Color(0xFFD6AE59);
  static const Color goldHighlight = Color(0xFFE3BD68);
  static const Color goldExtraLight = Color(0xFFF3D27C);
  static const Color goldDark = Color(0xFFAB8239);
  static const Color goldShadow = Color(0xFF98702F);
  static const Color goldDeepShadow = Color(0xFF825D24);

  // پس‌زمینه تیره (نه مشکی خالص)
  static const Color darkBg = Color(0xFF141414);
  static const Color darkSurface = Color(0xFF1F1B14);
  static const Color darkBorder = Color(0xFF3A3226);

  // پس‌زمینه روشن (کرم گرم، هماهنگ با طلایی)
  static const Color lightBg = Color(0xFFFBF6EC);
  static const Color lightBgSecondary = Color(0xFFF2E7D0);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE3D5B0);

  // نگهداری نام‌های قبلی برای سازگاری با کدهای موجود
  static const Color primaryBlue = goldPrimary;
  static const Color lightBlue = goldLight;
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
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      primaryColor: AppColors.goldPrimary,
      fontFamily: fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.goldPrimary,
        secondary: AppColors.goldLight,
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
