import 'package:flutter/material.dart';

import 'app_borders.dart';
import 'app_button_styles.dart';
import 'app_color_roles.dart';
import 'app_color_schemes.dart';
import 'app_input_themes.dart';
import 'app_surface_themes.dart';
import 'app_text_theme.dart';

class AppTheme {
  const AppTheme._();

  static final ThemeData standard = _build(
    AppColorSchemes.standard,
    AppBorders.standard,
  );

  static final ThemeData highContrast = _build(
    AppColorSchemes.highContrast,
    AppBorders.highContrast,
  );

  static ThemeData _build(ColorScheme c, AppBorders b) {
    final text = AppTextTheme.base;
    return ThemeData(
      useMaterial3: true,
      colorScheme: c,
      scaffoldBackgroundColor: c.surface,
      focusColor: c.focus,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      textTheme: text,
      cardTheme: AppSurfaceThemes.card(c, b),
      appBarTheme: AppSurfaceThemes.appBar(c, text),
      navigationBarTheme: AppSurfaceThemes.navigationBar(c, text),
      chipTheme: AppSurfaceThemes.chip(c, text, b),
      dividerTheme: AppSurfaceThemes.divider(c),
      inputDecorationTheme: AppInputThemes.field(c, text, b),
      switchTheme: AppInputThemes.toggle(c, b),
      filledButtonTheme: FilledButtonThemeData(
        style: AppButtonStyles.filled(c, b),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: AppButtonStyles.secondary(c, b),
      ),
      textButtonTheme: TextButtonThemeData(style: AppButtonStyles.ghost(c, b)),
    );
  }
}
