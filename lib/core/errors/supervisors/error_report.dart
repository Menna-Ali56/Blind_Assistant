import 'package:equatable/equatable.dart';

import '../failures/failure.dart';
import 'error_severity.dart';


class ErrorReport extends Equatable {
  const ErrorReport({
    required this.failure,
    required this.severity,
    required this.source,
    required this.at,
    this.occurrences = 1,
    this.shouldAnnounce = true,
    this.isRepeating = false,
  });

  final Failure failure;
  final ErrorSeverity severity;


  final String source;
  final DateTime at;


  final int occurrences;

  final bool shouldAnnounce;


  final bool isRepeating;


  bool get canRetry => failure.isRetryable && !isRepeating;

  @override
  List<Object?> get props => [
    failure,
    severity,
    source,
    at,
    occurrences,
    shouldAnnounce,
    isRepeating,
  ];
}
