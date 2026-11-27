import 'dart:typed_data';

/// 16-bit PCM audio. Speech recognizers and wake word engines usually
/// expect 16 kHz, mono.
class AudioFormat {
  const AudioFormat({
    this.sampleRate = defaultSampleRate,
    this.channels = defaultChannels,
  });

  static const int defaultSampleRate = 16000;
  static const int defaultChannels = 1;
  static const int bytesPerSample = 2;
  static const AudioFormat speech = AudioFormat();

  final int sampleRate;
  final int channels;

  int get bytesPerSecond => sampleRate * channels * bytesPerSample;

  Duration durationOf(int byteCount) => Duration(
    microseconds: byteCount * Duration.microsecondsPerSecond ~/ bytesPerSecond,
  );
}

/// Raw audio that was captured.
class AudioClip {
  const AudioClip(this.pcm, {this.format = AudioFormat.speech});

  final Uint8List pcm;
  final AudioFormat format;

  Duration get duration => format.durationOf(pcm.lengthInBytes);

  bool get isEmpty => pcm.isEmpty;
}
