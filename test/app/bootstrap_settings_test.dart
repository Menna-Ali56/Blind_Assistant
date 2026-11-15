import 'package:baseer/core/di/injector.dart';
import 'package:baseer/core/errors/errors_module.dart';
import 'package:baseer/core/storage/in_memory_secure_store.dart';
import 'package:baseer/core/storage/secure_store.dart';
import 'package:baseer/core/storage/secure_store_json.dart';
import 'package:baseer/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:baseer/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:baseer/features/settings/settings_module.dart';
import 'package:baseer/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:baseer/features/theme/presentation/cubit/theme_state.dart';
import 'package:baseer/features/theme/theme_module.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  test('load at startup applies saved highContrast theme', () async {
    final store = InMemorySecureStore();
    await store.writeJson(SettingsRepositoryImpl.storageKey, {
      'highContrast': true,
      'textScale': 1.5,
    });
    final locator = GetIt.asNewInstance()
      ..registerLazySingleton<SecureStore>(() => store);
    configureDependencies([
      const ErrorsModule(),
      const ThemeModule(),
      const SettingsModule(),
    ], locator: locator);

    await locator<SettingsCubit>().load();

    expect(locator<ThemeCubit>().state.variant, ThemeVariant.highContrast);
    expect(locator<ThemeCubit>().state.textScale, 1.5);
    await locator.reset();
  });
}
