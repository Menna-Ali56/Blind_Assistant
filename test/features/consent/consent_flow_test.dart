import 'package:baseer/core/consent/consent.dart';
import 'package:baseer/core/navigation/app_destination.dart';
import 'package:baseer/core/navigation/redirect_chain.dart';
import 'package:baseer/core/navigation/router_factory.dart';
import 'package:baseer/core/output/output.dart';
import 'package:baseer/core/storage/storage.dart';
import 'package:baseer/features/consent/consent.dart';
import 'package:baseer/features/consent/data/repositories/consent_repository_impl.dart';
import 'package:baseer/features/consent/presentation/pages/consent_flow_page.dart';
import 'package:baseer/features/permissions/permissions.dart';
import 'package:baseer/features/permissions/presentation/pages/permission_flow_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../permissions/permission_test_support.dart';

const String _homeMarker = 'home page';

ConsentCubit _makeConsent({ConsentRepositoryImpl? repository}) {
  return ConsentCubit(
    repository: repository ?? ConsentRepositoryImpl(InMemorySecureStore()),
    granted: GrantedConsent(),
    output: OutputCoordinator(const SilentOutputChannel()),
    languageCode: () => 'en',
  );
}

Future<void> _pumpApp(
  WidgetTester tester,
  PermissionsCubit permissions,
  ConsentCubit consent,
) async {
  final router = buildRouter(
    (destination) => Text('$_homeMarker ${destination.name}'),
    extraRoutes: [permissionsRoute(), consentRoute()],
    redirect: chainRedirects([
      permissionsRedirect(permissions),
      consentRedirect(consent, skipPaths: const {permissionsPath}),
    ]),
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider<PermissionsCubit>.value(value: permissions),
        BlocProvider<ConsentCubit>.value(value: consent),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('first launch navigates permissions -> consent -> home', (
    tester,
  ) async {
    final permissions = PermissionsHarness();
    final consent = _makeConsent();
    addTearDown(permissions.cubit.close);
    addTearDown(consent.close);

    await _pumpApp(tester, permissions.cubit, consent);
    expect(find.byType(PermissionFlowPage), findsOneWidget);

    for (var i = 0; i < PermissionKind.values.length; i++) {
      await tester.tap(find.text('Allow'));
      await tester.pumpAndSettle();
    }
    expect(find.byType(ConsentFlowPage), findsOneWidget);

    for (final label in ['Allow', 'Not now', 'Allow']) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }

    expect(
      find.text('$_homeMarker ${AppDestination.initial.name}'),
      findsOneWidget,
    );
    expect(consent.granted.allows(ConsentScope.imageUpload), isTrue);
    expect(consent.granted.allows(ConsentScope.audioUpload), isFalse);
    expect(consent.granted.allows(ConsentScope.locationShare), isTrue);
  });

  testWidgets('already consented launch skips straight to home', (
    tester,
  ) async {
    final permissions = PermissionsHarness();
    for (final kind in PermissionKind.values) {
      permissions.repository.current[kind] = AccessStatus.granted;
    }
    final repository = ConsentRepositoryImpl(InMemorySecureStore());
    await repository.save(
      const ConsentRecord(
        granted: {ConsentScope.imageUpload},
        policyVersion: ConsentPolicy.version,
      ),
    );
    final consent = _makeConsent(repository: repository);
    addTearDown(permissions.cubit.close);
    addTearDown(consent.close);

    await _pumpApp(tester, permissions.cubit, consent);

    expect(
      find.text('$_homeMarker ${AppDestination.initial.name}'),
      findsOneWidget,
    );
  });
}
