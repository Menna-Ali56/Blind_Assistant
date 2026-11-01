import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import 'app_borders.dart';
import 'app_color_roles.dart';
import 'widget_state_values.dart';

class AppButtonStyles {
  const AppButtonStyles._();

  static ButtonStyle filled(ColorScheme c, AppBorders b) => _style(
    c,
    b,
    background: c.primary,
    foreground: c.onPrimary,
    border: Colors.transparent,
  );

  static ButtonStyle secondary(ColorScheme c, AppBorders b) => _style(
    c,
    b,
    background: c.raised,
    foreground: c.onSurface,
    border: c.primary,
  );

  static ButtonStyle ghost(ColorScheme c, AppBorders b) => _style(
    c,
    b,
    background: Colors.transparent,
    foreground: c.muted,
    border: c.border,
  );

  static ButtonStyle _style(
    ColorScheme c,
    AppBorders b, {
    required Color background,
    required Color foreground,
    required Color border,
  }) {
    return ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(
        Size(AppDimens.minTouch, AppDimens.buttonHeight),
      ),
      padding: const WidgetStatePropertyAll(AppDimens.controlPadding),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppDimens.radius)),
        ),
      ),
      backgroundColor: valueWhen(
        WidgetState.disabled,
        yes: c.raisedHigh,
        otherwise: background,
      ),
      foregroundColor: valueWhen(
        WidgetState.disabled,
        yes: c.muted.withValues(alpha: AppDimens.disabledAlpha),
        otherwise: foreground,
      ),
      side: WidgetStateProperty.resolveWith((states) {
        final focused = states.contains(WidgetState.focused);
        return BorderSide(
          color: focused ? c.focus : border,
          width: focused ? AppDimens.focusWidth : b.control,
        );
      }),
    );
  }
}
