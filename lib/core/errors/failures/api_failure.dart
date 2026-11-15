import '../mappers/error_code_registry.dart';
import 'failure.dart';
import 'retry_hint.dart';

class ApiFailure extends Failure {
  const ApiFailure({
    required this.errorCode,
    required super.messageKey,
    required this.retryHint,
    this.statusCode,
    this.requestId,
  }) : super(
         code: errorCode,
         isRetryable:
             retryHint == RetryHint.sameRequest ||
             retryHint == RetryHint.newCapture,
       );

  factory ApiFailure.fromCode(
    String errorCode, {
    int? statusCode,
    String? requestId,
  }) {
    final rule = ErrorCodeRegistry.ruleFor(errorCode);
    return ApiFailure(
      errorCode: errorCode,
      messageKey: rule.messageKey,
      retryHint: rule.retry,
      statusCode: statusCode,
      requestId: requestId,
    );
  }

  final String errorCode;
  final int? statusCode;
  final String? requestId;

  @override
  final RetryHint retryHint;

  @override
  Map<String, Object?> get logFields => {
    ...super.logFields,
    'statusCode': statusCode,
    'requestId': requestId,
  };

  @override
  List<Object?> get props => [...super.props, statusCode, retryHint];
}
