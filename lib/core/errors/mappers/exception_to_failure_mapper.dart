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
    if (error is Failure) return error;
    if (error is NetworkException) return const NetworkFailure();
    if (error is ServerException) return const ServerFailure();
    if (error is AppTimeoutException) return const TimeoutFailure();
    if (error is PermissionException) return const PermissionFailure();
    if (error is CameraException) return const CameraFailure();
    if (error is MicrophoneException) return const MicrophoneFailure();
    if (error is StorageException) return const StorageFailure();
    if (error is ModelException) return const ModelFailure();
    if (error is OcrException) return const OcrFailure();
    if (error is SpeechException) return const SpeechFailure();
    if (error is AppException) return const UnknownFailure();
    return const UnknownFailure();
  }
}
