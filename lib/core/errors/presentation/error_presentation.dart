import 'package:equatable/equatable.dart';

import '../failures/cancelled_failure.dart';
import '../mappers/exception_to_failure_mapper.dart';
import '../messages/error_message_mapper.dart';

class ErrorPresentation extends Equatable {
  const ErrorPresentation({
    required this.message,
    required this.canRetry,
    this.isSilent = false,
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
    );
  }

  final String message;
  final bool canRetry;
  final bool isSilent;

  @override
  List<Object> get props => [message, canRetry, isSilent];
}
