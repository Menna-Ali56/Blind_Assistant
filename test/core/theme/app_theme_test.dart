import 'package:baseer/core/constants/app_dimens.dart';
import 'package:baseer/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final entry in {
    'standard': AppTheme.standard,
    'high contrast': AppTheme.highContrast,
  }.entries) {
    group(entry.key, () {
      final theme = entry.value;

      test('buttons meet the touch target size', () {
        final styles = [
          theme.filledButtonTheme.style,
          theme.outlinedButtonTheme.style,
          theme.textButtonTheme.style,
        ];
        for (final style in styles) {
          final size = style!.minimumSize!.resolve({})!;
          expect(size.height, greaterThanOrEqualTo(AppDimens.minTouch));
          expect(size.width, greaterThanOrEqualTo(AppDimens.minTouch));
        }
      });

      test('uses material 3 in dark mode', () {
        expect(theme.useMaterial3, isTrue);
        expect(theme.brightness, Brightness.dark);
      });
    });
  }
}
