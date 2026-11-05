import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show PlatformException;

import '../exceptions/exceptions.dart';
import '../failures/failures.dart';
import 'dio_failure_mapper.dart';
import 'platform_failure_mapper.dart';

class ExceptionToFailureMapper {
  const ExceptionToFailureMapper();

  Failure map(Object error) {
    return switch (error) {
      Failure() => error,
      DioException() => const DioFailureMapper().map(error, map),
      NetworkException() ||
      SocketException() ||
      HttpException() => const NetworkFailure(),
      ServerException(:final statusCode) => ServerFailure(
        statusCode: statusCode,
      ),
      AppTimeoutException() || TimeoutException() => const TimeoutFailure(),
      PermissionException(:final permission, :final isPermanentlyDenied) =>
        PermissionFailure(
          permission: permission,
          isPermanentlyDenied: isPermanentlyDenied,
        ),
      CameraException() => const CameraFailure(),
      MicrophoneException() => const MicrophoneFailure(),
      StorageException() || FileSystemException() => const StorageFailure(),
      ModelException() => const ModelFailure(),
      OcrException(code: 'ocr_no_text') => const OcrFailure.noText(),
      OcrException() => const OcrFailure(),
      SpeechException() => const SpeechFailure(),
      PlatformException() => const PlatformFailureMapper().map(error),
      _ => const UnknownFailure(),
    };
  }
}
