import 'dart:typed_data';

import 'audio_format.dart';

abstract final class PcmWav {
  static const int headerBytes = 44;
  static const int _bitsPerSample = AudioFormat.bytesPerSample * 8;
  static const int _formatChunkBytes = 16;
  static const int _pcmFormatTag = 1;
  static const int _riffExtraBytes = headerBytes - 8;

  static Uint8List wrap(
    Uint8List pcm, {
    AudioFormat format = AudioFormat.speech,
  }) {
    final header = ByteData(headerBytes);
    final blockAlign = format.channels * AudioFormat.bytesPerSample;

    void ascii(int offset, String text) {
      for (var i = 0; i < text.length; i++) {
        header.setUint8(offset + i, text.codeUnitAt(i));
      }
    }

    ascii(0, 'RIFF');
    header.setUint32(4, _riffExtraBytes + pcm.lengthInBytes, Endian.little);
    ascii(8, 'WAVE');
    ascii(12, 'fmt ');
    header.setUint32(16, _formatChunkBytes, Endian.little);
    header.setUint16(20, _pcmFormatTag, Endian.little);
    header.setUint16(22, format.channels, Endian.little);
    header.setUint32(24, format.sampleRate, Endian.little);
    header.setUint32(28, format.bytesPerSecond, Endian.little);
    header.setUint16(32, blockAlign, Endian.little);
    header.setUint16(34, _bitsPerSample, Endian.little);
    ascii(36, 'data');
    header.setUint32(40, pcm.lengthInBytes, Endian.little);

    return (BytesBuilder(copy: false)
          ..add(header.buffer.asUint8List())
          ..add(pcm))
        .toBytes();
  }
}
