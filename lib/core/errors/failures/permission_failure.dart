import 'failure.dart';

class PermissionFailure extends Failure {
  const PermissionFailure({this.permission, this.isPermanentlyDenied = false})
    : super(
        messageKey: isPermanentlyDenied
            ? 'permission_permanently_denied'
            : 'permission_denied',
        code: 'permission',
        isRetryable: !isPermanentlyDenied,
      );

  final String? permission;
  final bool isPermanentlyDenied;

  @override
  List<Object?> get props => [...super.props, permission, isPermanentlyDenied];
}
