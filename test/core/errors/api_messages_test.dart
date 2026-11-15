import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/core/errors/messages/error_messages_ar.dart';
import 'package:baseer/core/errors/messages/error_messages_en.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mapper = ErrorMessageMapper();

  test('every message key of the registry has ar and en text', () {
    final keys = {
      ...ErrorCodeRegistry.rules.values.map((rule) => rule.messageKey),
      ErrorCodeRegistry.unknown.messageKey,
    };

    for (final key in keys) {
      expect(arabicErrorMessages[key], isNotEmpty, reason: key);
      expect(englishErrorMessages[key], isNotEmpty, reason: key);
    }
  });

  test('action labels exist in both languages', () {
    for (final hint in [
      RetryHint.sameRequest,
      RetryHint.newCapture,
      RetryHint.login,
    ]) {
      expect(mapper.actionLabel(hint, languageCode: 'ar'), isNotEmpty);
      expect(mapper.actionLabel(hint, languageCode: 'en'), isNotEmpty);
    }
    expect(mapper.actionLabel(RetryHint.none, languageCode: 'en'), isNull);
  });

  test('api failure speaks message and action', () {
    final presentation = ErrorPresentation.from(
      ApiFailure.fromCode('ERR_IMAGE_BLURRY'),
      languageCode: 'en',
    );

    expect(presentation.spoken, contains(presentation.message));
    expect(presentation.spoken, contains(presentation.actionLabel!));
  });

  test('other failures keep speaking only the message', () {
    final presentation = ErrorPresentation.from(
      const NetworkFailure(),
      languageCode: 'en',
    );

    expect(presentation.spoken, presentation.message);
  });
}
