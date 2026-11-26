import 'dart:typed_data';

import 'spotter_defaults.dart';

abstract final class Pcm16Converter {
  static Float32List toFloat(Uint8List bytes) {
    final count = bytes.length ~/ SpotterDefaults.pcmBytesPerSample;
    final view = ByteData.sublistView(bytes);
    final samples = Float32List(count);
    for (var i = 0; i < count; i++) {
      final offset = i * SpotterDefaults.pcmBytesPerSample;
      samples[i] =
          view.getInt16(offset, Endian.little) / SpotterDefaults.pcmScale;
    }
    return samples;
  }
}
