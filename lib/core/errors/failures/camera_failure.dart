import 'failure.dart';

class CameraFailure extends Failure {
  const CameraFailure()
    : super(
        messageKey: 'camera_unavailable',
        code: 'camera',
        isRetryable: true,
      );
}
