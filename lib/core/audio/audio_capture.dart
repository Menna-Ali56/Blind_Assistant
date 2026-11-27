import 'dart:typed_data';

import '../errors/errors.dart';
import 'audio_format.dart';

abstract interface class AudioCapture {
  bool get isCapturing;

  Stream<Uint8List> get chunks;

  Stream<Failure> get failures;

  Future<Result<void>> start();

  Future<Result<AudioClip>> stop();

  Future<void> cancel();

  Future<void> dispose();
}
