import 'failure.dart';

class PermissionFailure extends Failure {
  const PermissionFailure()
      : super(messageKey: 'permission_denied', code: 'permission');
}
