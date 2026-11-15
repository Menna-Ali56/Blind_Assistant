import 'package:baseer/core/constants/app_defaults.dart';
import 'package:baseer/core/errors/exceptions/permission_exception.dart';
import 'package:baseer/core/execution/execution.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_execution_environment.dart';

const _localRun = RunLocal(
  timeout: AppDefaults.localInferenceTimeout,
  minConfidence: AppDefaults.localConfidenceThreshold,
);

ExecutionDecision _route(
  ExecutionFeature feature,
  FakeExecutionEnvironment environment,
) => ExecutionRouter(environment).route(feature);

void main() {
  test('missing permission blocks every lane', () {
    final environment = FakeExecutionEnvironment(grantedPermissions: {});
    expect(
      _route(ExecutionFeature.route, environment),
      const Unavailable(
        UnavailableReason.permissionMissing,
        permission: AppPermission.location,
      ),
    );
  });

  test('local only feature never goes to the cloud', () {
    final environment = FakeExecutionEnvironment();
    expect(
      _route(ExecutionFeature.obstacleAwareness, environment),
      const Unavailable(UnavailableReason.noLocalModel),
    );
    environment.readyModels = {ExecutionFeature.obstacleAwareness};
    expect(_route(ExecutionFeature.obstacleAwareness, environment), _localRun);
  });

  test('cloud only feature needs network then consent', () {
    final environment = FakeExecutionEnvironment(isOnline: false);
    const feature = ExecutionFeature.sceneDescription;
    expect(
      _route(feature, environment),
      const Unavailable(UnavailableReason.offline),
    );
    environment
      ..isOnline = true
      ..consent = false;
    expect(
      _route(feature, environment),
      const Unavailable(UnavailableReason.consentMissing),
    );
    environment.consent = true;
    expect(_route(feature, environment), const RunCloud());
  });

  test('every feature has a policy with at least one lane', () {
    for (final feature in ExecutionFeature.values) {
      expect(executionPolicyOf(feature).placement.lanes, isNotEmpty);
    }
  });
}
