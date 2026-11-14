import 'package:baseer/core/errors/errors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('request id does not break repeat detection', () {
    final first = ApiFailure.fromCode('ERR_IMAGE_BLURRY', requestId: 'a');
    final second = ApiFailure.fromCode('ERR_IMAGE_BLURRY', requestId: 'b');

    expect(first, second);
  });

  test('log fields carry ids and no user content', () {
    final failure = ApiFailure.fromCode(
      'ERR_IMAGE_BLURRY',
      statusCode: 422,
      requestId: 'abc',
    );

    expect(failure.logFields.keys, {'messageKey', 'statusCode', 'requestId'});
  });

  test('unknown code is a generic failure with a retry', () {
    final failure = ApiFailure.fromCode('ERR_SOMETHING_NEW');

    expect(failure.messageKey, 'unexpected_error');
    expect(failure.isRetryable, isTrue);
  });

  test('login code is not retryable and asks for sign in', () {
    final failure = ApiFailure.fromCode('ERR_UNAUTHORIZED');

    expect(failure.retryHint, RetryHint.login);
    expect(failure.isRetryable, isFalse);
  });

  test('supervisor treats a user fixable failure as a warning', () {
    final report = ErrorSupervisor().reportFailure(
      ApiFailure.fromCode('ERR_IMAGE_BLURRY'),
    );

    expect(report.severity, ErrorSeverity.warning);
  });
}
