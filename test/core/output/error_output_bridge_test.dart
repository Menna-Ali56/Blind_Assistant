import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/core/output/output.dart';
import 'package:flutter_test/flutter_test.dart';

import 'output_test_support.dart';

void main() {
  late DateTime clock;
  late RecordingOutputChannel channel;
  late OutputCoordinator coordinator;
  late ErrorSupervisor supervisor;
  late ErrorOutputBridge bridge;

  setUp(() {
    clock = DateTime(2026);
    channel = RecordingOutputChannel();
    coordinator = OutputCoordinator(channel);
    supervisor = ErrorSupervisor(now: () => clock);
    bridge = ErrorOutputBridge(
      supervisor: supervisor,
      coordinator: coordinator,
      languageCode: () => 'en',
    )..start();
  });

  tearDown(() async {
    await bridge.stop();
    await coordinator.dispose();
    await supervisor.dispose();
  });

  test('CameraFailure speaks one high priority message', () async {
    supervisor.reportFailure(const CameraFailure());
    await pumpEventQueue();
    expect(channel.spoken, hasLength(1));
    expect(channel.priorities.single, OutputPriority.high);
    expect(channel.haptics, [OutputHaptic.heavy]);
  });

  test('CancelledFailure is not spoken', () async {
    supervisor
      ..reportFailure(const CancelledFailure())
      ..reportFailure(const NetworkFailure());
    await pumpEventQueue();
    expect(channel.spoken, hasLength(1));
    expect(channel.spoken.single, contains('internet'));
  });

  test('same failure twice inside repeatWindow is spoken once', () async {
    supervisor
      ..reportFailure(const TimeoutFailure())
      ..reportFailure(const TimeoutFailure());
    await pumpEventQueue();
    expect(channel.spoken, hasLength(1));
  });
}
