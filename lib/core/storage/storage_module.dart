import 'package:get_it/get_it.dart';

import '../di/di_module.dart';
import 'flutter_secure_store.dart';
import 'secure_store.dart';

class StorageModule implements DiModule {
  const StorageModule();

  @override
  void register(GetIt locator) {
    locator.registerLazySingleton<SecureStore>(
      () => const FlutterSecureStore(),
    );
  }
}
