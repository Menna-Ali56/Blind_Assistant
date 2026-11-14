import 'package:baseer/app/app_modules.dart';
import 'package:baseer/core/auth/auth.dart';
import 'package:baseer/core/di/injector.dart';
import 'package:baseer/core/execution/execution.dart';
import 'package:baseer/core/network/connectivity_monitor.dart';
import 'package:baseer/core/output/output.dart';
import 'package:baseer/core/safety/safety.dart';
import 'package:baseer/core/storage/in_memory_secure_store.dart';
import 'package:baseer/core/storage/secure_store.dart';
import 'package:baseer/features/consent/consent.dart';
import 'package:baseer/features/permissions/permissions.dart';
import 'package:baseer/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../core/network/fake_connectivity_monitor.dart';

void main() {
  test('every app module resolves cleanly', () async {
    final locator = GetIt.asNewInstance()..allowReassignment = true;
    configureDependencies(appModules, locator: locator);
    locator
      ..registerLazySingleton<SecureStore>(InMemorySecureStore.new)
      ..registerLazySingleton<ConnectivityMonitor>(FakeConnectivityMonitor.new)
      ..registerLazySingleton<AudioFocus>(NoAudioFocus.new);

    expect(locator<ExecutionRouter>(), isA<ExecutionRouter>());
    expect(locator<OutputCoordinator>(), isA<OutputCoordinator>());
    expect(locator<SafeStateGuard>(), isA<SafeStateGuard>());
    expect(locator<ConsentCubit>(), isA<ConsentCubit>());
    expect(locator<PermissionsCubit>(), isA<PermissionsCubit>());
    expect(locator<SettingsCubit>(), isA<SettingsCubit>());
    expect(locator<SessionProvider>(), isA<SessionProvider>());

    await locator.reset();
  });
}
