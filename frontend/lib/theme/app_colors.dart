import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors
  static const Color primaryGreen = Color(0xFF0B5D3B);
  static const Color darkGreen = Color(0xFF12372A);
  static const Color deepGreen = Color(0xFF073B2A);

  // Light green palette
  static const Color lightGreen = Color(0xFFE4F3EA);
  static const Color softGreen = Color(0xFFF0F8F3);
  static const Color mintGreen = Color(0xFFD8F0E2);

  // Background colors
  static const Color background = Color(0xFFF7FBF8);
  static const Color cream = Color(0xFFFFFCF4);
  static const Color card = Color(0xFFFFFFFF);

  // Text colors
  static const Color textPrimary = Color(0xFF12372A);
  static const Color textSecondary = Color(0xFF63756C);
  static const Color textMuted = Color(0xFF94A39C);

  // Status colors
  static const Color success = Color(0xFF238B5A);
  static const Color warning = Color(0xFFE3A72F);
  static const Color error = Color(0xFFD9534F);
  static const Color info = Color(0xFF3E7CB1);

  // Borders and dividers
  static const Color border = Color(0xFFE1EAE4);
  static const Color divider = Color(0xFFEAF0EC);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // Recommendation colors
  static const Color excellent = Color(0xFF0B5D3B);
  static const Color good = Color(0xFF3B8C63);
  static const Color moderate = Color(0xFFE3A72F);

  // AI analysis gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, Color(0xFF168A58)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Soft background gradient
  static const LinearGradient softGradient = LinearGradient(
    colors: [background, softGreen],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
