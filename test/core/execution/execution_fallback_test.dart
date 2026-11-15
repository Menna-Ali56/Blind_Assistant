import 'package:baseer/core/errors/failures/failures.dart';
import 'package:baseer/core/execution/execution.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_execution_environment.dart';

const _feature = ExecutionFeature.currency;

FakeExecutionEnvironment _environment({
  bool online = true,
  bool consent = true,
  bool modelReady = true,
}) => FakeExecutionEnvironment(
  isOnline: online,
  consent: consent,
  readyModels: modelReady ? {_feature} : {},
);

ExecutionDecision _route(FakeExecutionEnvironment environment) =>
    ExecutionRouter(environment).route(_feature);

ExecutionDecision _fallback(FakeExecutionEnvironment environment) =>
    ExecutionRouter(environment).fallback(_feature);

void main() {
  test('local first runs locally when the model is ready', () {
    expect(_route(_environment()), isA<RunLocal>());
  });

  test('local first uses the cloud when the model is missing', () {
    expect(_route(_environment(modelReady: false)), const RunCloud());
  });

  test('offline without a model reports offline', () {
    expect(
      _route(_environment(online: false, modelReady: false)),
      const Unavailable(UnavailableReason.offline),
    );
  });

  test('low confidence falls back to the cloud when allowed', () {
    expect(_fallback(_environment()), const RunCloud());
  });

  test('low confidence is uncertain when offline or without consent', () {
    const uncertain = Unavailable(UnavailableReason.lowConfidence);
    expect(_fallback(_environment(online: false)), uncertain);
    expect(_fallback(_environment(consent: false)), uncertain);
  });

  test('local only features have no fallback', () {
    final environment = _environment();
    expect(
      ExecutionRouter(environment).fallback(ExecutionFeature.voiceCommand),
      const Unavailable(UnavailableReason.lowConfidence),
    );
  });

  test('unavailable converts to a matching failure', () {
    expect(
      const Unavailable(UnavailableReason.offline).toFailure(),
      isA<ExecutionFailure>(),
    );
    expect(
      const Unavailable(
        UnavailableReason.permissionMissing,
        permission: 'camera',
      ).toFailure(),
      isA<PermissionFailure>(),
    );
  });
}
