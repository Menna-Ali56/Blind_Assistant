import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

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
      return const PermissionFailure();
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
      return const OcrFailure();
    }

    // Speech exceptions
    if (error is SpeechException) {
      return const SpeechFailure();
    }

    // Dart exceptions
    if (error is SocketException) {
      return const NetworkFailure();
    }

    if (error is TimeoutException) {
      return const TimeoutFailure();
    }

    // Unknown app exception
    if (error is AppException) {
      return const UnknownFailure();
    }

    return const UnknownFailure();
  }

  Failure _mapDioException(DioException error) {
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
      return const UnknownFailure();
    }

    if (error.error is SocketException) {
      return const NetworkFailure();
    }

    if (error.error is TimeoutException) {
      return const TimeoutFailure();
    }

    return const UnknownFailure();
  }
}