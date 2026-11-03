import 'package:baseer/core/errors/errors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mapper = ExceptionToFailureMapper();

  test('maps network exception to network failure', () {
    expect(mapper.map(const NetworkException()), isA<NetworkFailure>());
  });

  test('maps camera exception to camera failure', () {
    expect(mapper.map(const CameraException()), isA<CameraFailure>());
  });

  test('maps unknown object to unknown failure', () {
    expect(mapper.map(Exception('private detail')), isA<UnknownFailure>());
  });
}
