import 'package:equatable/equatable.dart';

import 'retry_hint.dart';

abstract class Failure extends Equatable {
  const Failure({
    required this.messageKey,
    required this.code,
    this.isRetryable = false,
  });

  // text key for ui error text
  final String messageKey;
  final String code;
  final bool isRetryable;

  RetryHint get retryHint =>
      isRetryable ? RetryHint.sameRequest : RetryHint.none;

  Map<String, Object?> get logFields => {'messageKey': messageKey};

  @override
  List<Object?> get props => [messageKey, code, isRetryable];
}
