import 'package:equatable/equatable.dart';

import '../failures/api_failure.dart';
import '../failures/cancelled_failure.dart';
import '../failures/retry_hint.dart';
import '../mappers/exception_to_failure_mapper.dart';
import '../messages/error_message_mapper.dart';

class ErrorPresentation extends Equatable {
  const ErrorPresentation({
    required this.message,
    required this.canRetry,
    this.isSilent = false,
    this.retryHint = RetryHint.none,
    this.actionLabel,
    this.speaksAction = false,
  });

  factory ErrorPresentation.from(
    Object error, {
    required String languageCode,
    ExceptionToFailureMapper failures = const ExceptionToFailureMapper(),
    ErrorMessageMapper messages = const ErrorMessageMapper(),
  }) {
    final failure = failures.map(error);
    return ErrorPresentation(
      message: messages.map(failure, languageCode: languageCode),
      canRetry: failure.isRetryable,
      isSilent: failure is CancelledFailure,
      retryHint: failure.retryHint,
      actionLabel: messages.actionLabel(
        failure.retryHint,
        languageCode: languageCode,
      ),
      speaksAction: failure is ApiFailure,
    );
  }

  final String message;
  final bool canRetry;
  final bool isSilent;
  final RetryHint retryHint;
  final String? actionLabel;
  final bool speaksAction;

  String get spoken {
    final label = actionLabel;
    return speaksAction && label != null ? '$message $label' : message;
  }

  @override
  List<Object?> get props => [
    message,
    canRetry,
    isSilent,
    retryHint,
    actionLabel,
    speaksAction,
  ];
}
