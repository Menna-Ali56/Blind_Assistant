import 'package:baseer/core/accessibility/text_scale_builder.dart';
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

  testWidgets('text scale is clamped', (tester) async {
    late double scale;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(3)),
        child: Builder(
          builder: (context) => appTextScaleBuilder(
            context,
            Builder(
              builder: (inner) {
                scale = MediaQuery.textScalerOf(inner).scale(10) / 10;
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
    expect(scale, AppDimens.maxTextScale);
  });
}
