import 'dart:math';

import 'package:blind_app/core/theme/app_color_roles.dart';
import 'package:blind_app/core/theme/app_color_schemes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

double contrast(Color a, Color b) {
  final first = a.computeLuminance();
  final second = b.computeLuminance();
  return (max(first, second) + 0.05) / (min(first, second) + 0.05);
}

List<(String, Color, Color)> textPairs(ColorScheme c) => [
  ('text on background', c.onSurface, c.surface),
  ('text on raised', c.onSurface, c.raised),
  ('muted on background', c.muted, c.surface),
  ('muted on raised', c.muted, c.raised),
  ('muted on raised high', c.muted, c.raisedHigh),
  ('on primary', c.onPrimary, c.primary),
  ('primary on background', c.primary, c.surface),
  ('primary on positive', c.primary, c.positiveContainer),
  ('warning on warning container', c.warning, c.warningContainer),
  ('danger on danger container', c.danger, c.dangerContainer),
  ('danger on background', c.danger, c.surface),
  ('on danger', c.onError, c.danger),
];

List<(String, Color, Color)> shapePairs(ColorScheme c) => [
  ('border on background', c.border, c.surface),
  ('border on raised', c.border, c.raised),
  ('focus on background', c.focus, c.surface),
  ('focus on raised', c.focus, c.raised),
];

void check(
  String name,
  ColorScheme scheme, {
  required double text,
  required double shape,
}) {
  group(name, () {
    final rules = {textPairs(scheme): text, shapePairs(scheme): shape};
    for (final rule in rules.entries) {
      for (final (label, front, back) in rule.key) {
        test(label, () {
          expect(contrast(front, back), greaterThanOrEqualTo(rule.value));
        });
      }
    }
  });
}

void main() {
  check('standard', AppColorSchemes.standard, text: 4.5, shape: 3);
  check('high contrast', AppColorSchemes.highContrast, text: 7, shape: 7);
}
