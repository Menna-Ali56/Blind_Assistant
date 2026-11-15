import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../core/di/di_module.dart';
import '../core/errors/errors.dart';
import '../core/navigation/app_destination.dart';
import '../core/safety/safety.dart';
import '../core/tasks/task_controller.dart';

class SafetyModule implements DiModule {
  const SafetyModule();

  @override
  void register(GetIt locator) {
    locator.registerLazySingleton<SafeStateGuard>(
      () => SafeStateGuard(
        supervisor: locator<ErrorSupervisor>(),
        tasks: locator<TaskController>(),
        goHome: () => locator<GoRouter>().go(AppDestination.initial.path),
      ),
      dispose: (guard) => guard.stop(),
    );
  }
}
