import 'package:baseer/core/accessibility/text_scale.dart';
import 'package:baseer/core/constants/app_defaults.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('extra scale multiplies a small system scale', () {
    expect(effectiveTextScale(system: 1, extra: 1.5), 1.5);
  });

  test('result stops at the maximum scale', () {
    final result = effectiveTextScale(system: 1.5, extra: 2);
    expect(result, AppDefaults.maxTextScale);
  });

  test('result never goes below a large system scale', () {
    expect(effectiveTextScale(system: 2.5, extra: 2), 2.5);
  });
}
