import 'execution_decision.dart';
import 'execution_environment.dart';
import 'execution_feature.dart';
import 'execution_lane.dart';
import 'execution_matrix.dart';
import 'execution_policy.dart';
import 'unavailable_reason.dart';

class ExecutionRouter {
  const ExecutionRouter(this._environment, {this.policyOf = executionPolicyOf});

  final ExecutionEnvironment _environment;
  final PolicyLookup policyOf;

  ExecutionDecision route(ExecutionFeature feature) {
    final policy = policyOf(feature);
    final missing = _missingPermission(policy);
    if (missing != null) {
      return Unavailable(
        UnavailableReason.permissionMissing,
        permission: missing,
      );
    }
    final blocked = <UnavailableReason>[];
    for (final lane in policy.placement.lanes) {
      final reason = _blockOf(lane, feature);
      if (reason == null) return _decisionFor(lane, policy);
      blocked.add(reason);
    }
    return Unavailable(blocked.reduce(_mostActionable));
  }

  ExecutionDecision fallback(ExecutionFeature feature) {
    final canFallBack =
        policyOf(feature).placement.hasCloudFallback &&
        _blockOf(ExecutionLane.cloud, feature) == null;
    return canFallBack
        ? const RunCloud()
        : const Unavailable(UnavailableReason.lowConfidence);
  }

  String? _missingPermission(ExecutionPolicy policy) => policy.permissions
      .where((name) => !_environment.grantedPermissions.contains(name))
      .firstOrNull;

  UnavailableReason? _blockOf(ExecutionLane lane, ExecutionFeature feature) =>
      switch (lane) {
        ExecutionLane.local =>
          _environment.isLocalModelReady(feature)
              ? null
              : UnavailableReason.noLocalModel,
        ExecutionLane.cloud => _cloudBlock(feature),
      };

  UnavailableReason? _cloudBlock(ExecutionFeature feature) {
    if (!_environment.isOnline) return UnavailableReason.offline;
    if (!_environment.hasCloudConsent(feature)) {
      return UnavailableReason.consentMissing;
    }
    return null;
  }

  ExecutionDecision _decisionFor(ExecutionLane lane, ExecutionPolicy policy) =>
      switch (lane) {
        ExecutionLane.local => RunLocal(
          timeout: policy.localTimeout,
          minConfidence: policy.minConfidence,
        ),
        ExecutionLane.cloud => const RunCloud(),
      };

  UnavailableReason _mostActionable(UnavailableReason a, UnavailableReason b) =>
      a.index <= b.index ? a : b;
}
