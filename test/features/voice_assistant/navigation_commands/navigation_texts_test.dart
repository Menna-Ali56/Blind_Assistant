import 'package:baseer/core/constants/app_languages.dart';
import 'package:baseer/core/navigation/app_destination.dart';
import 'package:baseer/features/voice_assistant/navigation_commands/texts/navigation_texts_lookup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const languages = [AppLanguages.arabic, AppLanguages.english];

  for (final language in languages) {
    group(language, () {
      final texts = navigationTextsFor(language);

      test('every destination has a spoken name', () {
        expect(texts.screens.keys, containsAll(AppDestination.values));
        for (final destination in AppDestination.values) {
          expect(texts.screenName(destination), isNotEmpty);
        }
      });

      test('settings has a spoken name', () {
        expect(texts.settings, isNotEmpty);
      });

      test('confirmation holds the screen name', () {
        expect(texts.confirmation(texts.settings), contains(texts.settings));
      });
    });
  }

  test('both languages differ', () {
    expect(
      navigationTextsFor(AppLanguages.arabic),
      isNot(navigationTextsFor(AppLanguages.english)),
    );
  });

  test('unknown language falls back to english', () {
    expect(navigationTextsFor('fr'), navigationTextsFor(AppLanguages.english));
  });
}
