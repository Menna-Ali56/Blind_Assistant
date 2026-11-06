import 'package:equatable/equatable.dart';

import '../constants/app_defaults.dart';
import 'execution_lane.dart';

class ExecutionPolicy extends Equatable {
  const ExecutionPolicy({
    required this.placement,
    required this.permissions,
    this.minConfidence = AppDefaults.localConfidenceThreshold,
    this.localTimeout = AppDefaults.localInferenceTimeout,
  });

  final ExecutionPlacement placement;
  final Set<String> permissions;
  final double minConfidence;
  final Duration localTimeout;

  @override
  List<Object> get props => [
    placement,
    permissions,
    minConfidence,
    localTimeout,
  ];
}
