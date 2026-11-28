import 'package:baseer/features/camera_capture/camera_capture.dart';
import 'package:baseer/features/camera_capture/presentation/texts/camera_texts_ar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'camera_page_support.dart';
import 'camera_test_support.dart';

Future<CameraHarness> _captured(WidgetTester tester) async {
  final harness = await pumpCameraPage(tester);
  await tester.tap(find.text(harness.texts.captureAction));
  await settle(tester);
  return harness;
}

void main() {
  testWidgets('ready shows the preview with labeled controls', (tester) async {
    final handle = tester.ensureSemantics();
    final harness = await pumpCameraPage(tester);

    expect(find.byKey(previewKey), findsOneWidget);
    expect(find.bySemanticsLabel(harness.texts.previewLabel), findsOneWidget);
    expect(find.bySemanticsLabel(harness.texts.captureAction), findsOneWidget);
    handle.dispose();
  });

  testWidgets('capture shows the review with use and retake', (tester) async {
    final harness = await _captured(tester);

    expect(find.byType(Image), findsOneWidget);
    expect(find.text(harness.texts.useAction), findsOneWidget);
    expect(find.text(harness.texts.retakeAction), findsOneWidget);
  });

  testWidgets('retake goes back to the live preview', (tester) async {
    final harness = await _captured(tester);

    await tester.tap(find.text(harness.texts.retakeAction));
    await settle(tester);

    expect(find.byKey(previewKey), findsOneWidget);
  });

  testWidgets('use hands the image to the caller', (tester) async {
    CapturedImage? accepted;
    final harness = await pumpCameraPage(
      tester,
      onAccepted: (image) => accepted = image,
    );
    await tester.tap(find.text(harness.texts.captureAction));
    await settle(tester);

    await tester.tap(find.text(harness.texts.useAction));
    await settle(tester);

    expect(accepted, harness.session.image);
  });

  testWidgets('a failed start offers retry', (tester) async {
    final session = FakeCameraSession()..openError = StateError('no camera');
    final harness = await pumpCameraPage(tester, session: session);
    expect(find.byKey(previewKey), findsNothing);

    session.openError = null;
    await tester.tap(find.text(harness.texts.retryAction));
    await settle(tester);

    expect(find.byKey(previewKey), findsOneWidget);
  });

  testWidgets('arabic labels show for the arabic language', (tester) async {
    await pumpCameraPage(tester, language: 'ar');

    expect(find.text(arabicCameraTexts.captureAction), findsOneWidget);
  });
}
