import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../core/di/di_module.dart';
import '../core/navigation/router_factory.dart';
import '../features/permissions/permissions.dart';
import '../features/settings/settings_route.dart';
import 'app_pages.dart';

class NavigationModule implements DiModule {
  const NavigationModule();

  @override
  void register(GetIt locator) {
    locator.registerLazySingleton<GoRouter>(
          () => buildRouter(
        appPage,
        extraRoutes: [permissionsRoute(), settingsRoute()],
        redirect: permissionsRedirect(locator<PermissionsCubit>()),
      ),
      dispose: (router) => router.dispose(),
    );
  }
}
