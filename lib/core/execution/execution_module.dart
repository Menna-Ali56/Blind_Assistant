import 'package:get_it/get_it.dart';

import '../di/di_module.dart';
import 'execution_environment.dart';
import 'execution_router.dart';
import 'local_model_catalog.dart';

class ExecutionModule implements DiModule {
  const ExecutionModule();

  @override
  void register(GetIt locator) {
    if (!locator.isRegistered<LocalModelCatalog>()) {
      locator.registerLazySingleton<LocalModelCatalog>(NoLocalModels.new);
    }
    locator.registerLazySingleton<ExecutionRouter>(
      () => ExecutionRouter(locator<ExecutionEnvironment>()),
    );
  }
}
