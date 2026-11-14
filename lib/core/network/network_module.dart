import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../di/di_module.dart';
import '../tasks/task_id_generator.dart';
import 'api_client.dart';
import 'api_config.dart';
import 'attempt_tracker.dart';

class NetworkModule implements DiModule {
  const NetworkModule();

  @override
  void register(GetIt locator) {
    locator
      ..registerLazySingleton<Dio>(
        () => buildApiClient(
          baseUrl: ApiConfig.baseUrl,
          ids: locator<TaskIdGenerator>(),
        ),
      )
      ..registerFactory<AttemptTracker>(
        () => AttemptTracker(locator<TaskIdGenerator>()),
      );
  }
}
