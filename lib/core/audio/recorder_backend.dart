import 'dart:typed_data';

import 'audio_format.dart';

/// The plugin side of capturing, so the logic above it can be tested.
abstract interface class RecorderBackend {
  Future<Stream<Uint8List>> startStream(AudioFormat format);

  Future<void> stop();

  Future<void> dispose();
}
