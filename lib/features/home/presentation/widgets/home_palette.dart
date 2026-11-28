import 'package:flutter/material.dart';

import '../../domain/entities/home_quick_action.dart';

class ToneColors {
  const ToneColors({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

abstract final class HomePalette {
  static const Color heroDarkBg = Color(0xFF0F2137);
  static const Color heroAccentBg = Color(0xFF17B8A6);
  static const Color heroTitle = Color(0xFFFFFFFF);
  static const Color heroSubtitle = Color(0xFFE2ECF8);

  static const Map<HomeTone, ToneColors> _lightTones = {
    HomeTone.teal: ToneColors(
      background: Color(0xFFE3F7F4),
      foreground: Color(0xFF08756D),
    ),
    HomeTone.blue: ToneColors(
      background: Color(0xFFE7F0FD),
      foreground: Color(0xFF2860B8),
    ),
    HomeTone.purple: ToneColors(
      background: Color(0xFFEFE9FC),
      foreground: Color(0xFF6339B8),
    ),
    HomeTone.coral: ToneColors(
      background: Color(0xFFFCEBE4),
      foreground: Color(0xFFC4512D),
    ),
    HomeTone.amber: ToneColors(
      background: Color(0xFFFEF4D8),
      foreground: Color(0xFF946200),
    ),
    HomeTone.green: ToneColors(
      background: Color(0xFFE6F5E8),
      foreground: Color(0xFF28723D),
    ),
  };

  static ToneColors toneOf(HomeTone tone, ColorScheme scheme) {
    if (scheme.brightness == Brightness.dark) {
      return ToneColors(
        background: scheme.primaryContainer,
        foreground: scheme.primary,
      );
    }
    return _lightTones[tone]!;
  }

  static Color heroBackground(ColorScheme scheme) =>
      scheme.brightness == Brightness.dark
      ? scheme.surfaceContainerHighest
      : heroDarkBg;

  static Color heroIconBox(ColorScheme scheme) =>
      scheme.brightness == Brightness.dark ? scheme.primary : heroAccentBg;

  static Color heroIconColor(ColorScheme scheme) =>
      scheme.brightness == Brightness.dark ? scheme.onPrimary : heroDarkBg;

  static Color heroTitleColor(ColorScheme scheme) =>
      scheme.brightness == Brightness.dark ? scheme.onSurface : heroTitle;

  static Color heroSubtitleColor(ColorScheme scheme) =>
      scheme.brightness == Brightness.dark
      ? scheme.onSurfaceVariant
      : heroSubtitle;
}
