import 'package:baseer/core/errors/exceptions/permission_exception.dart';
import 'package:baseer/core/execution/execution_environment.dart';
import 'package:baseer/core/execution/execution_feature.dart';

class FakeExecutionEnvironment implements ExecutionEnvironment {
  FakeExecutionEnvironment({
    this.grantedPermissions = const {
      AppPermission.camera,
      AppPermission.microphone,
      AppPermission.location,
    },
    this.isOnline = true,
    this.consent = true,
    this.readyModels = const {},
  });

  @override
  Set<String> grantedPermissions;
  @override
  bool isOnline;
  bool consent;
  Set<ExecutionFeature> readyModels;

  @override
  bool hasCloudConsent(ExecutionFeature feature) => consent;

  @override
  bool isLocalModelReady(ExecutionFeature feature) =>
      readyModels.contains(feature);
}
