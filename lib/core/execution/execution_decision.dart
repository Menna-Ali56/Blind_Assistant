import 'package:equatable/equatable.dart';

import '../errors/failures/execution_failure.dart';
import '../errors/failures/failure.dart';
import '../errors/failures/permission_failure.dart';
import 'unavailable_reason.dart';

sealed class ExecutionDecision extends Equatable {
  const ExecutionDecision();

  @override
  List<Object?> get props => const [];
}

final class RunLocal extends ExecutionDecision {
  const RunLocal({required this.timeout, required this.minConfidence});

  final Duration timeout;
  final double minConfidence;

  @override
  List<Object?> get props => [timeout, minConfidence];
}

final class RunCloud extends ExecutionDecision {
  const RunCloud();
}

final class Unavailable extends ExecutionDecision {
  const Unavailable(this.reason, {this.permission});

  final UnavailableReason reason;
  final String? permission;

  Failure toFailure() => reason == UnavailableReason.permissionMissing
      ? PermissionFailure(permission: permission)
      : ExecutionFailure(reason);

  @override
  List<Object?> get props => [reason, permission];
}
