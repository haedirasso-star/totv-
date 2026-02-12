import 'package:flutter/material.dart';

/// ثوابت الألوان والتصميم
class AppTheme {
  // الألوان الرئيسية
  static const Color primaryOrange = Color(0xFFFFA726);
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color backgroundColor = Colors.black;
  static const Color cardColor = Color(0xFF1C1C1E);
  
  // الألوان الثانوية
  static const Color accentColor = Color(0xFFFF6F00);
  static const Color errorColor = Color(0xFFCF6679);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  
  // ألوان النص
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textDisabled = Color(0xFF757575);
  
  // الظلال
  static const Color shadowColor = Color(0x40000000);
  
  // الشفافية
  static const Color overlayDark = Color(0x99000000);
  static const Color overlayLight = Color(0x33FFFFFF);
  
  // الأبعاد
  static const double borderRadius = 12.0;
  static const double cardElevation = 0.0;
  static const double buttonRadius = 8.0;
  
  // التباعد
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // أحجام النصوص
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeXXLarge = 24.0;
  
  // Gradient
  static const Gradient primaryGradient = LinearGradient(
    colors: [primaryOrange, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const Gradient cardGradient = LinearGradient(
    colors: [Color(0xFF2C2C2E), Color(0xFF1C1C1E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Box Shadows
  static List<BoxShadow> get defaultShadow => [
    BoxShadow(
      color: shadowColor,
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: shadowColor,
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
}
