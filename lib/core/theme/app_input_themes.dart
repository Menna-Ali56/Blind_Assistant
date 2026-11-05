import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import 'app_borders.dart';
import 'app_color_roles.dart';
import 'widget_state_values.dart';

class AppInputThemes {
  const AppInputThemes._();

  static InputDecorationTheme field(ColorScheme c, TextTheme t, AppBorders b) {
    OutlineInputBorder line(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
      borderSide: BorderSide(color: color, width: width),
    );
    return InputDecorationTheme(
      filled: true,
      fillColor: c.raised,
      hintStyle: t.bodyLarge?.copyWith(color: c.muted),
      errorStyle: t.bodyMedium?.copyWith(color: c.danger),
      contentPadding: AppDimens.fieldPadding,
      enabledBorder: line(c.border, b.control),
      disabledBorder: line(c.borderSoft, b.control),
      focusedBorder: line(c.focus, AppDimens.focusWidth),
      errorBorder: line(c.danger, b.control),
      focusedErrorBorder: line(c.danger, AppDimens.focusWidth),
    );
  }

  static SwitchThemeData toggle(ColorScheme c, AppBorders b) {
    const on = WidgetState.selected;
    return SwitchThemeData(
      trackColor: valueWhen(on, yes: c.primary, otherwise: c.raisedHigh),
      thumbColor: valueWhen(on, yes: c.onPrimary, otherwise: c.onSurface),
      trackOutlineColor: valueWhen(
        on,
        yes: Colors.transparent,
        otherwise: c.border,
      ),
      trackOutlineWidth: WidgetStatePropertyAll(b.card),
    );
  }
}
