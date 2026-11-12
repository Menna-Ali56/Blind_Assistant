import 'package:baseer/core/navigation/app_destination.dart';
import 'package:baseer/core/navigation/router_factory.dart';
import 'package:baseer/features/permissions/permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'permission_test_support.dart';

const _flowText = 'flow page';

Future<GoRouter> _pump(WidgetTester tester, PermissionsCubit cubit) async {
  final router = buildRouter(
    (destination) => Text('page ${destination.name}'),
    extraRoutes: [
      GoRoute(
        path: permissionsPath,
        builder: (context, state) => const Text(_flowText),
      ),
    ],
    redirect: permissionsRedirect(cubit),
  );
  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pumpAndSettle();
  return router;
}

void main() {
  testWidgets('first launch opens the permission flow', (tester) async {
    final harness = PermissionsHarness();

    await _pump(tester, harness.cubit);

    expect(find.text(_flowText), findsOneWidget);
  });

  testWidgets('finished flow lets the app reach home', (tester) async {
    final harness = PermissionsHarness();
    final router = await _pump(tester, harness.cubit);

    harness.cubit.finish();
    router.go(AppDestination.initial.path);
    await tester.pumpAndSettle();

    expect(find.text('page ${AppDestination.initial.name}'), findsOneWidget);
  });

  testWidgets('granted permissions skip the flow', (tester) async {
    final harness = PermissionsHarness();
    for (final kind in PermissionKind.values) {
      harness.repository.current[kind] = AccessStatus.granted;
    }

    await _pump(tester, harness.cubit);

    expect(find.text('page ${AppDestination.initial.name}'), findsOneWidget);
  });
}
