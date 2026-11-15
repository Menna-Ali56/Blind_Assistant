import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/core/network/api_error_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'contract_files.dart';
import 'stub_adapter.dart';

Future<Failure> _failureFor(int status, Map<String, dynamic> body) async {
  final dio = Dio()
    ..httpClientAdapter = StubAdapter(status: status, body: body)
    ..interceptors.add(const ApiErrorInterceptor());
  try {
    await dio.get<dynamic>('/x');
  } on DioException catch (error) {
    return const ExceptionToFailureMapper().map(error);
  }
  throw StateError('request should fail');
}

void main() {
  test('every error fixture becomes an api failure with its rule', () async {
    for (final file in fixtureFiles('error')) {
      final body = readFixture(file);
      final code = body['errorCode'] as String;
      final failure = await _failureFor(body['statusCode'] as int, body);
      final rule = ErrorCodeRegistry.ruleFor(code);

      expect(failure, isA<ApiFailure>());
      expect(failure.messageKey, rule.messageKey);
      expect(failure.retryHint, rule.retry);
    }
  });

  test('blurry image can be retried with a new capture', () async {
    final body = readNamedFixture('error', 'ERR_IMAGE_BLURRY');
    final failure = await _failureFor(422, body);

    expect(failure.isRetryable, isTrue);
    expect(failure.retryHint, RetryHint.newCapture);
  });

  test('body without our shape falls back to the status mapping', () async {
    final failure = await _failureFor(502, {'oops': true});

    expect(failure, const ServerFailure(statusCode: 502));
  });
}
