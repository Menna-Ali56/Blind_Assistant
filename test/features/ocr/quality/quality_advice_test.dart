import 'package:baseer/core/errors/messages/error_message_mapper.dart';
import 'package:baseer/features/ocr/domain/quality/quality_issue.dart';
import 'package:baseer/features/ocr/presentation/advice/quality_advice.dart';
import 'package:baseer/features/ocr/presentation/texts/quality_texts_lookup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const advice = QualityAdvice();
  const mapper = ErrorMessageMapper();
  const languages = ['en', 'ar'];

  String say(QualityIssue issue, String language) =>
      advice.spokenFor(issue, languageCode: language);

  test('blurry and dark map to the shared server error codes', () {
    expect(advice.failureFor(QualityIssue.blurry)?.code, 'ERR_IMAGE_BLURRY');
    expect(advice.failureFor(QualityIssue.tooDark)?.code, 'ERR_IMAGE_TOO_DARK');
    expect(advice.failureFor(QualityIssue.tooBright), isNull);
  });

  for (final language in languages) {
    final texts = qualityTextsFor(language);

    test('$language blurry advice uses the error message and a tip', () {
      final failure = advice.failureFor(QualityIssue.blurry)!;
      final spoken = say(QualityIssue.blurry, language);
      expect(spoken, contains(mapper.map(failure, languageCode: language)));
      expect(spoken, contains(texts.moveCloser));
      expect(spoken, endsWith(texts.retake));
    });

    test('$language dark advice uses the error message without a tip', () {
      final failure = advice.failureFor(QualityIssue.tooDark)!;
      final spoken = say(QualityIssue.tooDark, language);
      expect(spoken, contains(mapper.map(failure, languageCode: language)));
      expect(spoken, isNot(contains(texts.moveCloser)));
    });

    test('$language bright advice has its own text', () {
      final spoken = say(QualityIssue.tooBright, language);
      expect(spoken, startsWith(texts.tooBright));
    });
  }
}
