import 'dart:async';
import 'dart:typed_data';

import 'package:baseer/core/audio/audio_format.dart';
import 'package:baseer/features/voice_assistant/data/audio_frame_source.dart';
import 'package:baseer/features/voice_assistant/data/frame_source_recorder_backend.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeFrameSource implements AudioFrameSource {
  final StreamController<Uint8List> controller =
      StreamController<Uint8List>.broadcast();
  int starts = 0;
  int stops = 0;
  int disposes = 0;

  @override
  Stream<Uint8List> get frames => controller.stream;

  @override
  Future<void> start() async => starts++;

  @override
  Future<void> stop() async => stops++;

  @override
  Future<void> dispose() async => disposes++;
}

void main() {
  late FakeFrameSource source;
  late FrameSourceRecorderBackend backend;

  setUp(() {
    source = FakeFrameSource();
    backend = FrameSourceRecorderBackend(source);
  });

  test('starts the shared source and hands out its frames', () async {
    final stream = await backend.startStream(AudioFormat.speech);
    final seen = <Uint8List>[];
    stream.listen(seen.add);

    source.controller.add(Uint8List.fromList([1, 2]));
    await pumpEventQueue();

    expect(source.starts, 1);
    expect(seen, hasLength(1));
  });

  test('stop stops the shared source', () async {
    await backend.stop();

    expect(source.stops, 1);
  });

  test('dispose leaves the shared source alone', () async {
    await backend.dispose();

    expect(source.disposes, 0);
  });
}
