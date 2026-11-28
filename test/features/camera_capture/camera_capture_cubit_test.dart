import 'package:baseer/features/camera_capture/camera_capture.dart';
import 'package:flutter_test/flutter_test.dart';

import 'camera_test_support.dart';

void main() {
  late CameraHarness harness;

  setUp(() => harness = CameraHarness());
  tearDown(() => harness.cubit.close());

  CameraStage stage() => harness.cubit.state.stage;

  Future<void> expectSpoken(CameraStage expected) async {
    await pumpEventQueue();
    expect(harness.channel.spoken, contains(harness.texts.spoken(expected)));
  }

  test('open reaches ready and speaks the guidance', () async {
    await harness.cubit.open();

    expect(stage(), CameraStage.ready);
    await expectSpoken(CameraStage.ready);
  });

  test('open failure is spoken and retry opens again', () async {
    harness.session.openError = StateError('no camera');
    await harness.cubit.open();
    expect(stage(), CameraStage.openFailed);
    await expectSpoken(CameraStage.openFailed);

    harness.session.openError = null;
    await harness.cubit.retry();

    expect(stage(), CameraStage.ready);
    expect(harness.session.opened, 2);
  });

  test('capture reaches review with the image', () async {
    await harness.cubit.open();
    await harness.cubit.capture();

    expect(stage(), CameraStage.review);
    expect(harness.cubit.state.image, harness.session.image);
    await expectSpoken(CameraStage.review);
  });

  test('capture failure is spoken and retry keeps the camera open', () async {
    await harness.cubit.open();
    harness.session.captureError = StateError('no photo');
    await harness.cubit.capture();
    expect(stage(), CameraStage.captureFailed);
    await expectSpoken(CameraStage.captureFailed);

    await harness.cubit.retry();

    expect(stage(), CameraStage.ready);
    expect(harness.session.opened, 1);
  });

  test('capture is ignored unless the camera is ready', () async {
    await harness.cubit.capture();

    expect(harness.session.captured, 0);
  });

  test('retake returns to ready and use accepts the image', () async {
    await harness.cubit.open();
    await harness.cubit.capture();
    harness.cubit.retake();
    expect(stage(), CameraStage.ready);

    await harness.cubit.capture();
    harness.cubit.use();

    expect(stage(), CameraStage.accepted);
    expect(harness.cubit.state.image, harness.session.image);
  });

  test('close releases the camera', () async {
    await harness.cubit.open();
    await harness.cubit.close();

    expect(harness.session.closed, 1);
  });
}
