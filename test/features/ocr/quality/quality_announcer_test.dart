import 'package:baseer/core/output/output.dart';
import 'package:baseer/features/ocr/domain/quality/quality_issue.dart';
import 'package:baseer/features/ocr/presentation/advice/quality_announcer.dart';
import 'package:baseer/features/ocr/presentation/policy/quality_flow_policy.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../core/output/output_test_support.dart';

void main() {
  late RecordingOutputChannel channel;
  late OutputCoordinator output;
  late DateTime clock;
  late QualityAnnouncer announcer;

  setUp(() {
    channel = RecordingOutputChannel();
    output = OutputCoordinator(channel);
    clock = DateTime(2026);
    announcer = QualityAnnouncer(
      output: output,
      languageCode: () => 'en',
      now: () => clock,
    );
  });

  tearDown(() => output.dispose());

  test('the same advice inside the repeat window is spoken once', () async {
    announcer.announce(QualityIssue.tooDark);
    announcer.announce(QualityIssue.tooDark);
    await pumpEventQueue();
    expect(channel.spoken, hasLength(1));
  });

  test('the same advice after the repeat window is spoken again', () async {
    announcer.announce(QualityIssue.tooDark);
    await pumpEventQueue();
    clock = clock.add(QualityFlowPolicy.repeatWindow);
    announcer.announce(QualityIssue.tooDark);
    await pumpEventQueue();
    expect(channel.spoken, hasLength(2));
  });

  test('a different issue is never dropped as a repeat', () async {
    announcer.announce(QualityIssue.tooDark);
    await pumpEventQueue();
    announcer.announce(QualityIssue.blurry);
    await pumpEventQueue();
    expect(channel.spoken, hasLength(2));
  });
}
