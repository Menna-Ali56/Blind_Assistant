import 'dart:typed_data';

import '../../../core/audio/audio_format.dart';
import '../../../core/audio/recorder_backend.dart';
import 'audio_frame_source.dart';
import 'spotter_defaults.dart';

/// Lets the audio capture use the microphone that the wake word spotter
/// already uses, so the app has one recorder and not two fighting for it.
///
/// The microphone has one owner at a time: stop the spotter before capturing
/// and start it again after. The format is fixed by the frame source
/// (16 kHz, mono).
class FrameSourceRecorderBackend implements RecorderBackend {
  const FrameSourceRecorderBackend(this._source);

  final AudioFrameSource _source;

  @override
  Future<Stream<Uint8List>> startStream(AudioFormat format) async {
    assert(
      format.sampleRate == SpotterDefaults.sampleRate &&
          format.channels == SpotterDefaults.channels,
      'The frame source only records ${SpotterDefaults.sampleRate} Hz mono',
    );
    await _source.start();
    return _source.frames;
  }

  @override
  Future<void> stop() => _source.stop();

  /// The frame source belongs to the DI container, so it is not disposed here.
  @override
  Future<void> dispose() async {}
}
