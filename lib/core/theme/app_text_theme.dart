import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';

class AppTextTheme {
  const AppTextTheme._();

  static final TextTheme base = TextTheme(
    displaySmall: _style(44, FontWeight.w800),
    headlineMedium: _style(28, FontWeight.w800),
    titleLarge: _style(22, FontWeight.w800),
    titleMedium: _style(17, FontWeight.w700),
    bodyLarge: _style(18, FontWeight.w400),
    bodyMedium: _style(15, FontWeight.w400),
    labelLarge: _style(20, FontWeight.w800),
    labelMedium: _style(15, FontWeight.w600),
    labelSmall: _style(14, FontWeight.w700),
  );

  static TextStyle _style(double size, FontWeight weight) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      height: AppDimens.lineHeight,
    );
  }
}
