import 'package:get_it/get_it.dart';

import '../core/consent/granted_consent.dart';
import '../core/di/di_module.dart';
import '../core/execution/execution.dart';
import '../core/network/connectivity_monitor.dart';
import '../core/network/connectivity_plus_monitor.dart';
import '../features/permissions/domain/entities/granted_permissions.dart';
import 'app_execution_environment.dart';

class EnvironmentModule implements DiModule {
  const EnvironmentModule();

  @override
  void register(GetIt locator) {
    if (!locator.isRegistered<ConnectivityMonitor>()) {
      locator.registerLazySingleton<ConnectivityMonitor>(
        ConnectivityPlusMonitor.new,
        dispose: (monitor) => monitor.stop(),
      );
    }
    locator.registerLazySingleton<ExecutionEnvironment>(
      () => AppExecutionEnvironment(
        permissions: locator<GrantedPermissions>(),
        connectivity: locator<ConnectivityMonitor>(),
        consent: locator<GrantedConsent>(),
        models: locator<LocalModelCatalog>(),
      ),
    );
  }
}
