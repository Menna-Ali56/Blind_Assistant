import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({
    required this.messageKey,
    required this.code,
    this.isRetryable = false,
  });

  /// Stable key resolved to localized text by the presentation layer.
  final String messageKey;
  final String code;
  final bool isRetryable;

  @override
  List<Object?> get props => [messageKey, code, isRetryable];
}
