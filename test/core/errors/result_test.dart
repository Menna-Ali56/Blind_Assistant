import 'package:baseer/core/errors/errors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fold returns success value', () {
    const result = ResultSuccess<int>(42);
    final value = result.fold(
      onSuccess: (data) => data.toString(),
      onFailure: (_) => 'failed',
    );
    expect(value, '42');
  });

  test('fold returns failure branch', () {
    const result = ResultFailure<int>(NetworkFailure());
    final value = result.fold(
      onSuccess: (_) => 'success',
      onFailure: (failure) => failure.code,
    );
    expect(value, 'network');
  });
}
