import 'package:baseer/app/app_execution_environment.dart';
import 'package:baseer/core/consent/consent.dart';
import 'package:baseer/core/execution/execution.dart';
import 'package:baseer/features/permissions/domain/entities/access_status.dart';
import 'package:baseer/features/permissions/domain/entities/granted_permissions.dart';
import 'package:baseer/features/permissions/domain/entities/permission_kind.dart';
import 'package:flutter_test/flutter_test.dart';

import '../core/network/fake_connectivity_monitor.dart';

class _FakeModels implements LocalModelCatalog {
  final Set<ExecutionFeature> ready = {};

  @override
  bool isReady(ExecutionFeature feature) => ready.contains(feature);
}

void main() {
  late GrantedPermissions permissions;
  late FakeConnectivityMonitor connectivity;
  late GrantedConsent consent;
  late _FakeModels models;
  late ExecutionRouter router;

  setUp(() {
    permissions = GrantedPermissions();
    connectivity = FakeConnectivityMonitor();
    consent = GrantedConsent();
    models = _FakeModels();
    router = ExecutionRouter(
      AppExecutionEnvironment(
        permissions: permissions,
        connectivity: connectivity,
        consent: consent,
        models: models,
      ),
    );
  });

  tearDown(() => connectivity.stop());

  test('routes currency to cloud when online with image consent', () {
    permissions.update({PermissionKind.camera: AccessStatus.granted});
    connectivity.setOnline(true);
    consent.update({ConsentScope.imageUpload});

    expect(router.route(ExecutionFeature.currency), isA<RunCloud>());
  });

  test('blocks cloud feature without matching consent scope', () {
    permissions.update({PermissionKind.microphone: AccessStatus.granted});
    connectivity.setOnline(true);
    consent.update({ConsentScope.imageUpload});

    expect(
      router.route(ExecutionFeature.conversationalAsr),
      const Unavailable(UnavailableReason.consentMissing),
    );
  });

  test('reports noLocalModel when NoLocalModels is active for localOnly', () {
    permissions.update({PermissionKind.camera: AccessStatus.granted});

    expect(
      router.route(ExecutionFeature.obstacleAwareness),
      const Unavailable(UnavailableReason.noLocalModel),
    );
  });

  test('uses local lane when local model catalog reports ready', () {
    permissions.update({PermissionKind.camera: AccessStatus.granted});
    models.ready.add(ExecutionFeature.currency);

    expect(router.route(ExecutionFeature.currency), isA<RunLocal>());
  });
}
