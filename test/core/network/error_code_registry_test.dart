import 'package:baseer/core/errors/errors.dart';
import 'package:flutter_test/flutter_test.dart';

import 'contract_files.dart';

const _hints = {
  'same_request': RetryHint.sameRequest,
  'new_capture': RetryHint.newCapture,
  'login': RetryHint.login,
  'none': RetryHint.none,
};

void main() {
  test('registry has exactly the codes of the contract', () {
    final codes = errorCodeRows().map((row) => row['code']).toSet();

    expect(ErrorCodeRegistry.rules.keys.toSet(), codes);
  });

  test('every rule matches message key and retry of the contract', () {
    for (final row in errorCodeRows()) {
      final rule = ErrorCodeRegistry.ruleFor(row['code'] as String);

      expect(rule.messageKey, row['messageKey']);
      expect(rule.retry, _hints[row['retry']]);
    }
  });

  test('unknown code gets the generic rule', () {
    final rule = ErrorCodeRegistry.ruleFor('ERR_SOMETHING_NEW');

    expect(rule.messageKey, 'unexpected_error');
  });
}
