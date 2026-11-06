import 'package:get_it/get_it.dart';

import '../di/di_module.dart';
import 'execution_environment.dart';
import 'execution_router.dart';

class ExecutionModule implements DiModule {
  const ExecutionModule();

  @override
  void register(GetIt locator) {
    locator.registerLazySingleton<ExecutionRouter>(
      () => ExecutionRouter(locator<ExecutionEnvironment>()),
    );
  }
}
