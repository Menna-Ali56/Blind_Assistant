import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../core/di/di_module.dart';
import '../core/navigation/redirect_chain.dart';
import '../core/navigation/router_factory.dart';
import '../features/consent/consent.dart';
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
        extraRoutes: [permissionsRoute(), consentRoute(), settingsRoute()],
        redirect: chainRedirects([
          permissionsRedirect(locator<PermissionsCubit>()),
          consentRedirect(
            locator<ConsentCubit>(),
            skipPaths: const {permissionsPath},
          ),
        ]),
      ),
      dispose: (router) => router.dispose(),
    );
  }
}
