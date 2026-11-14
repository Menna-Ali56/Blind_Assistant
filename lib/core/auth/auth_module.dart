import 'package:get_it/get_it.dart';

import '../di/di_module.dart';
import 'session_provider.dart';

class AuthModule implements DiModule {
  const AuthModule();

  @override
  void register(GetIt locator) {
    if (!locator.isRegistered<SessionProvider>()) {
      locator.registerLazySingleton<SessionProvider>(NoSession.new);
    }
  }
}
