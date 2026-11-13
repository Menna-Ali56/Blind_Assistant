import 'package:flutter/material.dart';

import '../../../../core/theme/app_color_roles.dart';

class SettingsPalette {
  const SettingsPalette._({
    required this.background,
    required this.card,
    required this.divider,
    required this.title,
    required this.subtitle,
    required this.sectionLabel,
    required this.accent,
    required this.accentDark,
    required this.onAccent,
    required this.tile,
    required this.hero,
    required this.onHero,
    required this.danger,
    required this.dangerTile,
    required this.toggleOff,
  });

  factory SettingsPalette.of(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return SettingsPalette._(
      background: c.surface,
      card: c.raised,
      divider: c.borderSoft,
      title: c.onSurface,
      subtitle: c.muted,
      sectionLabel: c.muted,
      accent: c.primary,
      accentDark: c.onPrimaryContainer,
      onAccent: c.onPrimary,
      tile: c.primaryContainer,
      hero: c.secondary,
      onHero: c.onSecondary,
      danger: c.danger,
      dangerTile: c.dangerContainer,
      toggleOff: c.border,
    );
  }

  final Color background;
  final Color card;
  final Color divider;
  final Color title;
  final Color subtitle;
  final Color sectionLabel;


  final Color accent;


  final Color accentDark;
  final Color onAccent;


  final Color tile;

  final Color hero;
  final Color onHero;
  final Color danger;
  final Color dangerTile;
  final Color toggleOff;

  static const double cardRadius = 24;
  static const double tileRadius = 14;
  static const double tileSize = 52;
  static const double rowMinHeight = 76;
  static const double pageGutter = 20;
}
