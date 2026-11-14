import 'package:get_it/get_it.dart';

import '../../core/di/cubit_registration.dart';
import '../../core/di/di_module.dart';
import '../../core/errors/errors.dart';
import '../../core/storage/secure_store.dart';
import '../theme/presentation/cubit/theme_cubit.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'domain/repositories/account_deletion_remote.dart';
import 'domain/repositories/preferences_remote.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/usecases/delete_user_data.dart';
import 'domain/usecases/load_settings.dart';
import 'domain/usecases/save_settings.dart';
import 'presentation/cubit/settings_cubit.dart';
import 'presentation/effects/preferences_sync_effect.dart';
import 'presentation/effects/theme_settings_effect.dart';

class SettingsModule implements DiModule {
  const SettingsModule();

  @override
  void register(GetIt locator) {
    if (!locator.isRegistered<PreferencesRemote>()) {
      locator.registerLazySingleton<PreferencesRemote>(NoPreferencesRemote.new);
    }
    if (!locator.isRegistered<AccountDeletionRemote>()) {
      locator.registerLazySingleton<AccountDeletionRemote>(
        NoRemoteDeletion.new,
      );
    }
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
        () => DeleteUserData(
          locator<SettingsRepository>(),
          remote: locator<AccountDeletionRemote>(),
        ),
      )
      ..registerSharedCubit<SettingsCubit>(
        (l) => SettingsCubit(
          loadSettings: l<LoadSettings>(),
          saveSettings: l<SaveSettings>(),
          deleteUserData: l<DeleteUserData>(),
          supervisor: l<ErrorSupervisor>(),
          effects: [
            ThemeSettingsEffect(l<ThemeCubit>()),
            PreferencesSyncEffect(l<PreferencesRemote>()),
          ],
        ),
      );
  }
}
