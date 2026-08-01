import 'package:flutter/material.dart';

abstract final class AppColors {
  // --- Primary Brand ---
  static const Color primary = Color(0xFF3B5BDB);
  static const Color primaryDark = Color(0xFF2F4AC4);
  static const Color accent = Color(0xFF4DABF7);
  static const Color accentTeal = Color(0xFF20C997);

  // --- Backgrounds ---
  static const Color background = Color(0xFFF0F4FF);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF8FAFF);

  // --- Text ---
  static const Color textPrimary = Color(0xFF0D1B4B);
  static const Color textSecondary = Color(0xFF5A6A94);
  static const Color textTertiary = Color(0xFFA0AECF);

  // --- Border & Dividers ---
  static const Color border = Color(0xFFDDE3F5);
  static const Color divider = Color(0xFFEEF2FF);

  // --- Semantic ---
  static const Color error = Color(0xFFFA5252);
  static const Color success = Color(0xFF40C057);
  static const Color warning = Color(0xFFFD7E14);
  static const Color info = Color(0xFF339AF0);

  // --- Flight Status ---
  static const Color boardingColor = Color(0xFF40C057);
  static const Color delayedColor = Color(0xFFFD7E14);
  static const Color cancelledColor = Color(0xFFFA5252);
  static const Color scheduledColor = Color(0xFF3B5BDB);
  static const Color departedColor = Color(0xFF7950F2);
  static const Color arrivedColor = Color(0xFF20C997);

  // --- Dark Mode ---
  static const Color darkBackground = Color(0xFF0B1023);
  static const Color darkSurface = Color(0xFF141D35);
  static const Color darkSurfaceVariant = Color(0xFF1C2840);
  static const Color darkTextPrimary = Color(0xFFF0F4FF);
  static const Color darkTextSecondary = Color(0xFF8A9BC5);
  static const Color darkBorder = Color(0xFF263058);

  // --- Gradients ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3B5BDB), Color(0xFF4DABF7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF2C46C5), Color(0xFF3B5BDB), Color(0xFF5C7CFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient boardingPassGradient = LinearGradient(
    colors: [Color(0xFF0B1023), Color(0xFF141D35), Color(0xFF1C2840)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF2F9E44), Color(0xFF40C057)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFFE67700), Color(0xFFFD7E14)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF6741D9), Color(0xFF7950F2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- AI / Services Gradients ---
  static const LinearGradient aiGradient = LinearGradient(
    colors: [Color(0xFF7950F2), Color(0xFF4DABF7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tealGradient = LinearGradient(
    colors: [Color(0xFF0CA678), Color(0xFF20C997)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient translatorGradient = LinearGradient(
    colors: [Color(0xFF1971C2), Color(0xFF339AF0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient promotionsGradient = LinearGradient(
    colors: [Color(0xFFE64980), Color(0xFFF06595)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFE8590C), Color(0xFFFD7E14)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
