import 'package:flutter_test/flutter_test.dart';

import 'package:baseer/core/constants/app_defaults.dart';
import 'package:baseer/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:baseer/features/theme/presentation/cubit/theme_state.dart';

void main() {
  late ThemeCubit cubit;

  setUp(() => cubit = ThemeCubit());
  tearDown(() => cubit.close());

  test('starts with the standard variant and default scale', () {
    expect(cubit.state, const ThemeState());
  });

  test('toggle switches between the two variants', () {
    cubit.toggleHighContrast();
    expect(cubit.state.variant, ThemeVariant.highContrast);
    cubit.toggleHighContrast();
    expect(cubit.state.variant, ThemeVariant.standard);
  });

  test('text scale stays inside the allowed range', () {
    cubit.changeTextScale(AppDefaults.maxTextScale + 1);
    expect(cubit.state.textScale, AppDefaults.maxTextScale);
    cubit.changeTextScale(AppDefaults.minTextScale - 1);
    expect(cubit.state.textScale, AppDefaults.minTextScale);
  });
}
