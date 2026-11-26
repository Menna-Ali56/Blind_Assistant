import 'dart:typed_data';

import 'package:baseer/features/voice_assistant/data/spotter_defaults.dart';
import 'package:baseer/features/voice_assistant/domain/entities/spotter_event.dart';
import 'package:flutter_test/flutter_test.dart';

import 'spotter_harness.dart';

void main() {
  late SpotterHarness h;

  setUp(() => h = SpotterHarness());

  test('emits an event for each keyword the engine reports', () async {
    h.engine.result = ['ya baseer'];
    final events = <SpotterEvent>[];
    h.spotter.events.listen(events.add);
    await h.spotter.start();
    h.source.controller.add(Uint8List(4));
    await settle();
    expect(events, [
      const SpotterEvent(
        keyword: 'ya baseer',
        confidence: SpotterDefaults.reportedConfidence,
      ),
    ]);
    expect(h.engine.received.single.length, 2);
  });

  test('start twice opens the source once', () async {
    await h.spotter.start();
    await h.spotter.start();
    expect(h.source.starts, 1);
  });

  test('stop releases source and engine and ignores later frames', () async {
    final events = <SpotterEvent>[];
    h.spotter.events.listen(events.add);
    h.engine.result = ['x'];
    await h.spotter.start();
    await h.spotter.stop();
    h.source.controller.add(Uint8List(4));
    await settle();
    expect(h.source.stops, 1);
    expect(h.engine.disposed, isTrue);
    expect(events, isEmpty);
  });

  test('can start again after stop', () async {
    await h.spotter.start();
    await h.spotter.stop();
    await h.spotter.start();
    expect(h.source.starts, 2);
  });
}
