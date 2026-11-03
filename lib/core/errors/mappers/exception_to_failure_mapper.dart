import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show PlatformException;

import '../exceptions/app_exception.dart';
import '../exceptions/camera_exception.dart';
import '../exceptions/microphone_exception.dart';
import '../exceptions/model_exception.dart';
import '../exceptions/network_exception.dart';
import '../exceptions/ocr_exception.dart';
import '../exceptions/permission_exception.dart';
import '../exceptions/server_exception.dart';
import '../exceptions/speech_exception.dart';
import '../exceptions/storage_exception.dart';
import '../exceptions/timeout_exception.dart';

import '../failures/camera_failure.dart';
import '../failures/cancelled_failure.dart';
import '../failures/failure.dart';
import '../failures/microphone_failure.dart';
import '../failures/model_failure.dart';
import '../failures/network_failure.dart';
import '../failures/ocr_failure.dart';
import '../failures/permission_failure.dart';
import '../failures/server_failure.dart';
import '../failures/speech_failure.dart';
import '../failures/storage_failure.dart';
import '../failures/timeout_failure.dart';
import '../failures/unknown_failure.dart';

class ExceptionToFailureMapper {
  const ExceptionToFailureMapper();

  Failure map(Object error) {
    // Already mapped failure
    if (error is Failure) {
      return error;
    }

    // Dio exceptions
    if (error is DioException) {
      return _mapDioException(error);
    }

    // Network exceptions
    if (error is NetworkException) {
      return const NetworkFailure();
    }

    // Server exceptions
    if (error is ServerException) {
      return ServerFailure(
        statusCode: error.statusCode,
      );
    }

    // Timeout exceptions
    if (error is AppTimeoutException) {
      return const TimeoutFailure();
    }

    // Permission exceptions
    if (error is PermissionException) {
      return PermissionFailure(
        permission: error.permission,
        isPermanentlyDenied: error.isPermanentlyDenied,
      );
    }

    // Camera exceptions
    if (error is CameraException) {
      return const CameraFailure();
    }

    // Microphone exceptions
    if (error is MicrophoneException) {
      return const MicrophoneFailure();
    }

    // Storage exceptions
    if (error is StorageException) {
      return const StorageFailure();
    }

    // Model exceptions
    if (error is ModelException) {
      return const ModelFailure();
    }

    // OCR exceptions
    if (error is OcrException) {
      return error.code == 'ocr_no_text'
          ? const OcrFailure.noText()
          : const OcrFailure();
    }

    // Speech exceptions
    if (error is SpeechException) {
      return const SpeechFailure();
    }

    // Dart / Flutter SDK exceptions
    if (error is SocketException || error is HttpException) {
      return const NetworkFailure();
    }

    if (error is TimeoutException) {
      return const TimeoutFailure();
    }

    if (error is FileSystemException) {
      return const StorageFailure();
    }

    if (error is PlatformException) {
      return _mapPlatformException(error);
    }

    return const UnknownFailure();
  }

  Failure _mapPlatformException(PlatformException error) {
    final code = error.code.toLowerCase();

    final isDenied = code.contains('denied') ||
        code.contains('permission') ||
        code.contains('unauthorized') ||
        code.contains('restricted');

    String? permission;
    if (code.contains('camera')) {
      permission = AppPermission.camera;
    } else if (code.contains('audio') ||
        code.contains('microphone') ||
        code.contains('record')) {
      permission = AppPermission.microphone;
    } else if (code.contains('speech')) {
      permission = AppPermission.speech;
    } else if (code.contains('storage') || code.contains('file')) {
      permission = AppPermission.storage;
    }

    if (isDenied) {
      return PermissionFailure(
        permission: permission,
        isPermanentlyDenied: code.contains('permanent'),
      );
    }

    return switch (permission) {
      AppPermission.camera => const CameraFailure(),
      AppPermission.microphone => const MicrophoneFailure(),
      AppPermission.speech => const SpeechFailure(),
      AppPermission.storage => const StorageFailure(),
      _ => const UnknownFailure(),
    };
  }

  Failure _mapDioException(DioException error) {
    // An interceptor may have wrapped our own error inside the DioException.
    final inner = error.error;
    if (inner is Failure) return inner;
    if (inner is AppException) return map(inner);

    final type = error.type;

    if (type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.receiveTimeout) {
      return const TimeoutFailure();
    }

    if (type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }

    if (type == DioExceptionType.badResponse) {
      return ServerFailure(
        statusCode: error.response?.statusCode,
      );
    }

    if (type == DioExceptionType.badCertificate) {
      return const NetworkFailure();
    }

    if (type == DioExceptionType.cancel) {
      return const CancelledFailure();
    }

    if (inner is SocketException) {
      return const NetworkFailure();
    }

    if (inner is TimeoutException) {
      return const TimeoutFailure();
    }

    return const UnknownFailure();
  }
}