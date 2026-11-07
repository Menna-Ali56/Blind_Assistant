import 'package:get_it/get_it.dart';

import '../di/di_module.dart';
import 'task_controller.dart';
import 'task_id_generator.dart';

class TasksModule implements DiModule {
  const TasksModule();

  @override
  void register(GetIt locator) {
    locator.registerLazySingleton<TaskIdGenerator>(UuidV4Generator.new);
    locator.registerLazySingleton<TaskController>(
      () => TaskController(idGenerator: locator<TaskIdGenerator>()),
      dispose: (controller) => controller.dispose(),
    );
  }
}
