import '../failures/cancelled_failure.dart';
import '../failures/execution_failure.dart';
import '../failures/failure.dart';
import '../failures/network_failure.dart';
import '../failures/permission_failure.dart';
import '../failures/timeout_failure.dart';
import 'error_severity.dart';


class ErrorPolicy {
  const ErrorPolicy();

  static const String _noTextCode = 'ocr_no_text';

  ErrorSeverity severityOf(Failure failure, {bool uncaught = false}) {
    if (failure is CancelledFailure) return ErrorSeverity.info;
    if (uncaught) return ErrorSeverity.critical;
    if (failure.code == _noTextCode) return ErrorSeverity.info;
    if (_isExpected(failure)) return ErrorSeverity.warning;
    return ErrorSeverity.error;
  }


  bool shouldAnnounce(Failure failure) => failure is! CancelledFailure;

  bool _isExpected(Failure failure) =>
      failure is PermissionFailure ||
      failure is ExecutionFailure ||
      failure is NetworkFailure ||
      failure is TimeoutFailure;
}
