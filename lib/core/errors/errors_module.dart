import 'package:get_it/get_it.dart';

import '../di/di_module.dart';
import 'handlers/error_handler.dart';
import 'supervisors/error_supervisor.dart';

class ErrorsModule implements DiModule {
  const ErrorsModule();

  @override
  void register(GetIt locator) {
    locator
      ..registerLazySingleton<ErrorHandler>(() => const ErrorHandler())
      ..registerLazySingleton<ErrorSupervisor>(
        () => ErrorSupervisor(errorHandler: locator<ErrorHandler>()),
        dispose: (supervisor) => supervisor.dispose(),
      );
  }
}
