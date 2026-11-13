import 'package:get_it/get_it.dart';

import '../../core/di/cubit_registration.dart';
import '../../core/di/di_module.dart';
import '../../core/errors/errors.dart';
import '../../core/storage/secure_store.dart';
import '../theme/presentation/cubit/theme_cubit.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/usecases/delete_user_data.dart';
import 'domain/usecases/load_settings.dart';
import 'domain/usecases/save_settings.dart';
import 'presentation/cubit/settings_cubit.dart';
import 'presentation/effects/theme_settings_effect.dart';

class SettingsModule implements DiModule {
  const SettingsModule();

  @override
  void register(GetIt locator) {
    locator
      ..registerLazySingleton<SettingsRepository>(
        () => SettingsRepositoryImpl(
          locator<SecureStore>(),
          errorHandler: locator<ErrorHandler>(),
        ),
      )
      ..registerLazySingleton<LoadSettings>(
        () => LoadSettings(locator<SettingsRepository>()),
      )
      ..registerLazySingleton<SaveSettings>(
        () => SaveSettings(locator<SettingsRepository>()),
      )
      ..registerLazySingleton<DeleteUserData>(
        () => DeleteUserData(locator<SettingsRepository>()),
      )
      ..registerSharedCubit<SettingsCubit>(
        (l) => SettingsCubit(
          loadSettings: l<LoadSettings>(),
          saveSettings: l<SaveSettings>(),
          deleteUserData: l<DeleteUserData>(),
          supervisor: l<ErrorSupervisor>(),
          effects: [ThemeSettingsEffect(l<ThemeCubit>())],
        ),
      );
  }
}
