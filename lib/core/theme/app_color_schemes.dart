import 'package:flutter/material.dart';

class AppColorSchemes {
  const AppColorSchemes._();

  static const standard = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF2DD4BF),
    onPrimary: Color(0xFF0A1F3D),
    primaryContainer: Color(0xFF0E3B3A),
    onPrimaryContainer: Color(0xFF2DD4BF),
    secondary: Color(0xFF12305A),
    onSecondary: Color(0xFFFFFFFF),
    tertiary: Color(0xFFFFB020),
    onTertiary: Color(0xFF0A1F3D),
    tertiaryContainer: Color(0xFF3A2A06),
    onTertiaryContainer: Color(0xFFFFB020),
    error: Color(0xFFFF8A8A),
    onError: Color(0xFF0A1F3D),
    errorContainer: Color(0xFF3D1212),
    onErrorContainer: Color(0xFFFF8A8A),
    surface: Color(0xFF0A1F3D),
    onSurface: Color(0xFFFFFFFF),
    onSurfaceVariant: Color(0xFFB8C7DC),
    surfaceContainer: Color(0xFF12305A),
    surfaceContainerHighest: Color(0xFF1B4175),
    outline: Color(0xFF6A8FC4),
    outlineVariant: Color(0xFF1B4175),
  );

  static const highContrast = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF2DD4BF),
    onPrimary: Color(0xFF000000),
    primaryContainer: Color(0xFF00302B),
    onPrimaryContainer: Color(0xFF2DD4BF),
    secondary: Color(0xFF000000),
    onSecondary: Color(0xFFFFFFFF),
    tertiary: Color(0xFFFFB020),
    onTertiary: Color(0xFF000000),
    tertiaryContainer: Color(0xFF2B1E00),
    onTertiaryContainer: Color(0xFFFFB020),
    error: Color(0xFFFF9A9A),
    onError: Color(0xFF000000),
    errorContainer: Color(0xFF330000),
    onErrorContainer: Color(0xFFFF9A9A),
    surface: Color(0xFF000000),
    onSurface: Color(0xFFFFFFFF),
    onSurfaceVariant: Color(0xFFE6E6E6),
    surfaceContainer: Color(0xFF000000),
    surfaceContainerHighest: Color(0xFF262626),
    outline: Color(0xFFFFFFFF),
    outlineVariant: Color(0xFFFFFFFF),
  );
}
