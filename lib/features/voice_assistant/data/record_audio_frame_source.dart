import 'dart:async';
import 'dart:typed_data';

import 'package:record/record.dart';

import '../../../core/errors/exceptions/microphone_exception.dart';
import 'audio_frame_source.dart';
import 'spotter_defaults.dart';

class RecordAudioFrameSource implements AudioFrameSource {
  RecordAudioFrameSource() : _recorder = AudioRecorder();

  static const _config = RecordConfig(
    encoder: AudioEncoder.pcm16bits,
    sampleRate: SpotterDefaults.sampleRate,
    numChannels: SpotterDefaults.channels,
  );

  final AudioRecorder _recorder;
  final StreamController<Uint8List> _frames = StreamController.broadcast();
  StreamSubscription<Uint8List>? _subscription;

  @override
  Stream<Uint8List> get frames => _frames.stream;

  @override
  Future<void> start() async {
    if (_subscription != null) return;
    try {
      final stream = await _recorder.startStream(_config);
      _subscription = stream.listen(_frames.add, onError: _frames.addError);
    } catch (error) {
      throw MicrophoneException(cause: error);
    }
  }

  @override
  Future<void> stop() async {
    final subscription = _subscription;
    _subscription = null;
    await subscription?.cancel();
    await _recorder.stop();
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _recorder.dispose();
    await _frames.close();
  }
}
