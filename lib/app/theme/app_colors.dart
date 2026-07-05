import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF2F6B4F);
  static const Color primaryDark = Color(0xFF1F4D39);
  static const Color accent = Color(0xFFA8D5BA);

  // Background & Surface
  static const Color background = Color(0xFFFAFAF7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color softSurface = Color(0xFFF1F5F2);

  // Text
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);

  // Border
  static const Color border = Color(0xFFE5E7EB);

  // Status
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF22C55E);
  static const Color danger = Color(0xFFEF4444);

  // Transparent & Overlay
  static const Color transparent = Colors.transparent;
  static Color primaryLight = primary.withValues(alpha: 0.08);
  static Color shadowLight = Colors.black.withValues(alpha: 0.05);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.08);
}
