import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'app_destination.dart';
import 'app_shell.dart';

typedef PageResolver = Widget Function(AppDestination destination);

GoRouter buildRouter(
  PageResolver pageFor, {
  List<RouteBase> extraRoutes = const [],
  GoRouterRedirect? redirect,
}) {
  return GoRouter(
    initialLocation: AppDestination.initial.path,
    redirect: redirect,
    onException: (context, state, router) {
      router.go(AppDestination.initial.path);
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          for (final item in AppDestination.values)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: item.path,
                  builder: (context, state) => pageFor(item),
                ),
              ],
            ),
        ],
      ),
      ...extraRoutes,
    ],
  );
}
