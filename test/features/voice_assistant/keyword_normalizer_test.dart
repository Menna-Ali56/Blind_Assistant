import 'package:baseer/features/voice_assistant/spotter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('arabic marks are removed', () {
    expect(KeywordNormalizer.normalize('\u0627\u064E\u0642'), '\u0627\u0642');
  });

  test('alef and ya and ta marbuta variants are unified', () {
    expect(
      KeywordNormalizer.normalize('\u0623\u0625\u0622'),
      '\u0627\u0627\u0627',
    );
    expect(KeywordNormalizer.normalize('\u0649'), '\u064A');
    expect(KeywordNormalizer.normalize('\u0629'), '\u0647');
  });

  test('spaces collapse and ends are trimmed', () {
    expect(KeywordNormalizer.normalize('  Read   Me '), 'read me');
  });
}
