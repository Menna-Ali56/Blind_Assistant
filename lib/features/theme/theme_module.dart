import 'package:get_it/get_it.dart';

import '../../core/di/cubit_registration.dart';
import '../../core/di/di_module.dart';
import 'presentation/cubit/theme_cubit.dart';

class ThemeModule implements DiModule {
  const ThemeModule();

  @override
  void register(GetIt locator) {
    locator.registerSharedCubit<ThemeCubit>((_) => ThemeCubit());
  }
}
