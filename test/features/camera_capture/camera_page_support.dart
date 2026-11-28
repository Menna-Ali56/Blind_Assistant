import 'package:baseer/features/camera_capture/camera_capture.dart';
import 'package:baseer/features/camera_capture/presentation/pages/camera_capture_page.dart';
import 'package:baseer/features/permissions/permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../permissions/permission_test_support.dart';
import 'camera_test_support.dart';

Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

Future<CameraHarness> pumpCameraPage(
  WidgetTester tester, {
  FakeCameraSession? session,
  String language = 'en',
  ValueChanged<CapturedImage>? onAccepted,
}) async {
  final permissions = PermissionsHarness(
    repository: FakePermissionRepository(
      current: {
        for (final kind in PermissionKind.values) kind: AccessStatus.granted,
      },
    ),
  );
  final harness = CameraHarness(session: session, language: language);
  await tester.pumpWidget(
    MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: permissions.cubit),
          BlocProvider.value(value: harness.cubit),
        ],
        child: CameraCapturePage(onAccepted: onAccepted ?? (_) {}),
      ),
    ),
  );
  await permissions.cubit.refresh();
  await settle(tester);
  return harness;
}
