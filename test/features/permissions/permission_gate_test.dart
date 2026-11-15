import 'package:baseer/features/permissions/permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'permission_test_support.dart';

const _childKey = Key('child');

Future<PermissionsHarness> _pump(
  WidgetTester tester, {
  AccessStatus status = AccessStatus.denied,
}) async {
  final harness = PermissionsHarness(
    repository: FakePermissionRepository()
      ..current[PermissionKind.camera] = status,
  );
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider.value(
        value: harness.cubit,
        child: const PermissionGate(
          kind: PermissionKind.camera,
          child: SizedBox(key: _childKey),
        ),
      ),
    ),
  );
  return harness;
}

void main() {
  testWidgets('shows nothing before the first check', (tester) async {
    await _pump(tester);

    expect(find.byKey(_childKey), findsNothing);
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('asks first and opens the child after a grant', (tester) async {
    final harness = await _pump(tester);
    await harness.cubit.refresh();
    await tester.pump();

    await tester.tap(find.text(harness.cubit.texts.allowAction));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(_childKey), findsOneWidget);
  });

  testWidgets('blocked permission offers settings', (tester) async {
    final harness = await _pump(tester, status: AccessStatus.blocked);
    await harness.cubit.refresh();
    await tester.pump();

    await tester.tap(find.text(harness.cubit.texts.settingsAction));

    expect(harness.repository.settingsOpened, 1);
  });

  testWidgets('child appears when the permission is granted later', (
    tester,
  ) async {
    final harness = await _pump(tester);
    await harness.cubit.refresh();
    await tester.pump();
    expect(find.byKey(_childKey), findsNothing);

    harness.repository.current[PermissionKind.camera] = AccessStatus.granted;
    await harness.cubit.refresh();
    await tester.pump();

    expect(find.byKey(_childKey), findsOneWidget);
  });

  testWidgets('the prompt is spoken when it appears', (tester) async {
    final harness = await _pump(tester);
    await harness.cubit.refresh();
    await tester.pump();

    expect(harness.channel.spoken.single, contains('camera'));
  });
}
