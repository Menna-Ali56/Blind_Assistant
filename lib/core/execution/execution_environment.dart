import 'execution_feature.dart';

abstract interface class ExecutionEnvironment {
  Set<String> get grantedPermissions;

  bool get isOnline;

  bool hasCloudConsent(ExecutionFeature feature);

  bool isLocalModelReady(ExecutionFeature feature);
}
