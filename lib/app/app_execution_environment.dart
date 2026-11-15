import '../core/consent/consent.dart';
import '../core/execution/execution.dart';
import '../core/network/connectivity_monitor.dart';
import '../features/permissions/domain/entities/granted_permissions.dart';

class AppExecutionEnvironment implements ExecutionEnvironment {
  AppExecutionEnvironment({
    required this._permissions,
    required this._connectivity,
    required this._consent,
    required this._models,
  });

  final GrantedPermissions _permissions;
  final ConnectivityMonitor _connectivity;
  final GrantedConsent _consent;
  final LocalModelCatalog _models;

  @override
  Set<String> get grantedPermissions => _permissions.names;

  @override
  bool get isOnline => _connectivity.isOnline;

  @override
  bool hasCloudConsent(ExecutionFeature feature) {
    final scope = consentScopeOf(feature);
    return scope == null || _consent.allows(scope);
  }

  @override
  bool isLocalModelReady(ExecutionFeature feature) => _models.isReady(feature);
}
