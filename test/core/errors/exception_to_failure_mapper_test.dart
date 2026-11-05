import 'package:baseer/core/errors/errors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mapper = ExceptionToFailureMapper();

  test('maps network exception to network failure', () {
    expect(mapper.map(const NetworkException()), isA<NetworkFailure>());
  });

  test('maps camera exception to camera failure', () {
    expect(mapper.map(const AppCameraException()), isA<CameraFailure>());
  });

  test('maps unknown object to unknown failure', () {
    expect(mapper.map(Exception('private detail')), isA<UnknownFailure>());
  });

  test('maps ocr without text to the no text failure', () {
    const error = OcrException.noText();
    expect(mapper.map(error), const OcrFailure.noText());
  });

  test('maps bad response to server failure with status', () {
    final error = DioException(
      requestOptions: RequestOptions(),
      type: DioExceptionType.badResponse,
      response: Response(requestOptions: RequestOptions(), statusCode: 503),
    );
    expect(mapper.map(error), const ServerFailure(statusCode: 503));
  });

  test('maps cancelled request to cancelled failure', () {
    final error = DioException(
      requestOptions: RequestOptions(),
      type: DioExceptionType.cancel,
    );
    expect(mapper.map(error), isA<CancelledFailure>());
  });

  test('maps denied camera platform error to permission failure', () {
    final error = PlatformException(code: 'CameraAccessDenied');
    final result = mapper.map(error) as PermissionFailure;
    expect(result.permission, AppPermission.camera);
  });

  test('maps other camera platform error to camera failure', () {
    final error = PlatformException(code: 'camera_busy');
    expect(mapper.map(error), isA<CameraFailure>());
  });
}
