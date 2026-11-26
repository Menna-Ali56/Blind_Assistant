import 'dart:typed_data';

abstract interface class AudioFrameSource {
  Stream<Uint8List> get frames;

  Future<void> start();

  Future<void> stop();

  Future<void> dispose();
}
