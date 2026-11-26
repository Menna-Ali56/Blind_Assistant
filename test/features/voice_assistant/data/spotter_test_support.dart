import 'dart:async';
import 'dart:typed_data';

import 'package:baseer/features/voice_assistant/data/audio_frame_source.dart';
import 'package:baseer/features/voice_assistant/data/keyword_engine.dart';
import 'package:baseer/features/voice_assistant/data/model_file_source.dart';
import 'package:crypto/crypto.dart';

String hashOf(List<int> bytes) => sha256.convert(bytes).toString();

class FakeModelFileSource implements ModelFileSource {
  FakeModelFileSource(this.files);

  final Map<String, List<int>> files;

  @override
  Future<bool> exists(String path) async => files.containsKey(path);

  @override
  Stream<List<int>> openRead(String path) => Stream.value(files[path]!);
}

class FakeAudioFrameSource implements AudioFrameSource {
  final StreamController<Uint8List> controller = StreamController.broadcast();
  int starts = 0;
  int stops = 0;

  @override
  Stream<Uint8List> get frames => controller.stream;

  @override
  Future<void> start() async => starts++;

  @override
  Future<void> stop() async => stops++;

  @override
  Future<void> dispose() async => controller.close();
}

class FakeKeywordEngine implements KeywordEngine {
  List<String> result = const [];
  Object? failure;
  final List<Float32List> received = [];
  bool disposed = false;

  @override
  List<String> accept(Float32List samples) {
    received.add(samples);
    final error = failure;
    if (error != null) throw error;
    return result;
  }

  @override
  void dispose() => disposed = true;
}
