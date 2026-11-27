import 'dart:typed_data';

import 'audio_format.dart';

abstract interface class RecorderBackend {
  Future<Stream<Uint8List>> startStream(AudioFormat format);

  Future<void> stop();

  Future<void> dispose();
}
