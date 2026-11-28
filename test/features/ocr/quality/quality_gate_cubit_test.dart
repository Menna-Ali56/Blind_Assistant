import 'dart:async';
import 'dart:typed_data';

import 'package:baseer/core/output/output.dart';
import 'package:baseer/core/tasks/task_controller.dart';
import 'package:baseer/features/camera/domain/entities/captured_image.dart';
import 'package:baseer/features/ocr/domain/quality/quality_gate.dart';
import 'package:baseer/features/ocr/domain/quality/quality_metrics.dart';
import 'package:baseer/features/ocr/presentation/advice/quality_announcer.dart';
import 'package:baseer/features/ocr/presentation/cubit/quality_flow_state.dart';
import 'package:baseer/features/ocr/presentation/cubit/quality_gate_cubit.dart';
import 'package:baseer/features/ocr/presentation/policy/quality_flow_policy.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../core/output/output_test_support.dart';
import 'quality_measurers.dart';

const QualityMetrics _blurred = QualityMetrics(sharpness: 1, brightness: 120);
const QualityMetrics _clear = QualityMetrics(sharpness: 900, brightness: 120);

void main() {
  late RecordingOutputChannel channel;
  late OutputCoordinator output;
  late TaskController tasks;

  QualityGateCubit build(List<Completer<QualityMetrics>> script) =>
      QualityGateCubit(
        gate: QualityGate(ScriptedMeasurer(script)),
        tasks: tasks,
        announcer: QualityAnnouncer(output: output, languageCode: () => 'en'),
      );

  CapturedImage photo(int id) => CapturedImage(
    bytes: Uint8List.fromList([id]),
    capturedAt: DateTime(2026),
  );

  setUp(() {
    channel = RecordingOutputChannel();
    output = OutputCoordinator(channel);
    tasks = TaskController();
  });

  tearDown(() async {
    tasks.dispose();
    await output.dispose();
  });

  test('a blurry photo is rejected and the fix is spoken', () async {
    final cubit = build([Completer<QualityMetrics>()..complete(_blurred)]);
    await cubit.check(photo(1));
    await pumpEventQueue();
    expect(cubit.state.status, QualityFlowStatus.rejected);
    expect(cubit.state.canRetake, isTrue);
    expect(channel.spoken.single, contains('Hold the phone steady'));
    expect(channel.priorities.single, QualityFlowPolicy.priority);
    await cubit.close();
  });

  test('a clear photo is accepted without speech', () async {
    final cubit = build([Completer<QualityMetrics>()..complete(_clear)]);
    await cubit.check(photo(1));
    await pumpEventQueue();
    expect(cubit.state.status, QualityFlowStatus.accepted);
    expect(channel.spoken, isEmpty);
    await cubit.close();
  });

  test('retake clears the rejection and allows a new photo', () async {
    final script = [
      Completer<QualityMetrics>()..complete(_blurred),
      Completer<QualityMetrics>()..complete(_clear),
    ];
    final cubit = build(script);
    await cubit.check(photo(1));
    cubit.retake();
    expect(cubit.state.status, QualityFlowStatus.idle);
    await cubit.check(photo(2));
    expect(cubit.state.status, QualityFlowStatus.accepted);
    expect(cubit.state.image, photo(2));
    await cubit.close();
  });

  test('a late result of a replaced check is ignored', () async {
    final first = Completer<QualityMetrics>();
    final second = Completer<QualityMetrics>();
    final cubit = build([first, second]);
    final older = cubit.check(photo(1));
    final newer = cubit.check(photo(2));
    second.complete(_clear);
    first.complete(_blurred);
    await Future.wait([older, newer]);
    await pumpEventQueue();
    expect(cubit.state.status, QualityFlowStatus.accepted);
    expect(cubit.state.image, photo(2));
    expect(channel.spoken, isEmpty);
    await cubit.close();
  });
}
