import 'package:flutter/material.dart';

class AppColorSchemes {
  const AppColorSchemes._();

  // Standard Light Theme
  static const standard = ColorScheme(
    brightness: Brightness.light,

    // Primary
    primary: Color(0xFF08756D),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE8F7F4),
    onPrimaryContainer: Color(0xFF064E49),

    // Secondary
    secondary: Color(0xFF12305A),
    onSecondary: Color(0xFFFFFFFF),

    // Tertiary
    tertiary: Color(0xFF8A5700),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFF1D6),
    onTertiaryContainer: Color(0xFF5C3B00),

    // Error
    error: Color(0xFFBA1B1B),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFCE8E6),
    onErrorContainer: Color(0xFF8C1D18),

    // Main surfaces
    surface: Color(0xFFF8FCFB),
    onSurface: Color(0xFF0A1F3D),
    onSurfaceVariant: Color(0xFF526779),

    // Surface containers
    surfaceContainer: Color(0xFFFFFFFF),
    surfaceContainerHighest: Color(0xFFEAF5F3),

    // Borders
    outline: Color(0xFF718985),
    outlineVariant: Color(0xFFD5E5E3),
  );

  // High Contrast Dark Theme
  static const highContrast = ColorScheme(
    brightness: Brightness.dark,

    // Primary
    primary: Color(0xFF2DD4BF),
    onPrimary: Color(0xFF000000),
    primaryContainer: Color(0xFF00302B),
    onPrimaryContainer: Color(0xFF2DD4BF),

    // Secondary
    secondary: Color(0xFF000000),
    onSecondary: Color(0xFFFFFFFF),

    // Tertiary
    tertiary: Color(0xFFFFB020),
    onTertiary: Color(0xFF000000),
    tertiaryContainer: Color(0xFF2B1E00),
    onTertiaryContainer: Color(0xFFFFB020),

    // Error
    error: Color(0xFFFF9A9A),
    onError: Color(0xFF000000),
    errorContainer: Color(0xFF330000),
    onErrorContainer: Color(0xFFFF9A9A),

    // Main surfaces
    surface: Color(0xFF000000),
    onSurface: Color(0xFFFFFFFF),
    onSurfaceVariant: Color(0xFFE6E6E6),

    // Surface containers
    surfaceContainer: Color(0xFF000000),
    surfaceContainerHighest: Color(0xFF262626),

    // Borders
    outline: Color(0xFFFFFFFF),
    outlineVariant: Color(0xFFFFFFFF),
  );
}
