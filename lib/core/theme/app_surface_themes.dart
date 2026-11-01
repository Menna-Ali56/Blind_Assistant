import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import 'app_borders.dart';
import 'app_color_roles.dart';
import 'widget_state_values.dart';

class AppSurfaceThemes {
  const AppSurfaceThemes._();

  static CardThemeData card(ColorScheme c, AppBorders b) => CardThemeData(
    color: c.raised,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimens.radius),
      side: BorderSide(color: c.borderSoft, width: b.card),
    ),
  );

  static AppBarTheme appBar(ColorScheme c, TextTheme t) => AppBarTheme(
    backgroundColor: c.surface,
    foregroundColor: c.onSurface,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    toolbarHeight: AppDimens.buttonHeight,
    titleTextStyle: t.titleLarge,
  );

  static NavigationBarThemeData navigationBar(ColorScheme c, TextTheme t) {
    return NavigationBarThemeData(
      height: AppDimens.navHeight,
      backgroundColor: c.surface,
      indicatorColor: c.primary,
      elevation: 0,
      labelTextStyle: valueWhen(
        WidgetState.selected,
        yes: t.labelSmall?.copyWith(color: c.onSurface),
        otherwise: t.labelSmall?.copyWith(color: c.muted),
      ),
      iconTheme: valueWhen(
        WidgetState.selected,
        yes: IconThemeData(color: c.onPrimary),
        otherwise: IconThemeData(color: c.muted),
      ),
    );
  }

  static ChipThemeData chip(ColorScheme c, TextTheme t, AppBorders b) {
    return ChipThemeData(
      backgroundColor: c.raisedHigh,
      labelStyle: t.labelMedium,
      shape: const StadiumBorder(),
      side: BorderSide(color: c.borderSoft, width: b.card),
      padding: AppDimens.controlPadding,
    );
  }

  static DividerThemeData divider(ColorScheme c) {
    return DividerThemeData(
      color: c.borderSoft,
      thickness: AppDimens.hairline,
      space: AppDimens.hairline,
    );
  }
}
