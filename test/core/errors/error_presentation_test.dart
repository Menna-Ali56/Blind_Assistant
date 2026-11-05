import 'package:baseer/core/errors/errors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('network error can be retried', () {
    final result = ErrorPresentation.from(
      const NetworkException(),
      languageCode: 'en',
    );
    expect(result.canRetry, isTrue);
    expect(result.message, isNotEmpty);
  });

  test('message follows the language code', () {
    const failure = NetworkFailure();
    final english = ErrorPresentation.from(failure, languageCode: 'en');
    final arabic = ErrorPresentation.from(failure, languageCode: 'ar');
    expect(arabic.message, isNot(english.message));
  });

  test('cancelled failure is silent', () {
    final result = ErrorPresentation.from(
      const CancelledFailure(),
      languageCode: 'en',
    );
    expect(result.isSilent, isTrue);
  });
}
