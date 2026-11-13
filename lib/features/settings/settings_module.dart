import 'package:get_it/get_it.dart';

import '../../core/di/di_module.dart';
import '../../core/errors/handlers/error_handler.dart';
import '../../core/storage/secure_store.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'domain/repositories/settings_repository.dart';

class SettingsModule implements DiModule {
  const SettingsModule();

  @override
  void register(GetIt locator) {
    locator.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(
        locator<SecureStore>(),
        errorHandler: locator<ErrorHandler>(),
      ),
    );
  }
}
