import 'dart:typed_data';

class WavWriter {
  WavWriter({required int rate, required int sampleCount})
    : _data = ByteData(headerBytes + sampleCount * bytesPerSample) {
    _header(rate, sampleCount * bytesPerSample);
  }

  static const int headerBytes = 44;
  static const int bytesPerSample = 2;
  static const int _bitsPerByte = 8;
  static const int _u16Size = 2;
  static const int _u32Size = 4;
  static const int _channels = 1;
  static const int _pcmFormat = 1;
  static const int _formatChunkBytes = 16;
  static const int _riffExtraBytes = 36;

  final ByteData _data;
  int _cursor = 0;

  Uint8List get bytes => _data.buffer.asUint8List();

  void sample(int value) {
    _data.setInt16(_cursor, value, Endian.little);
    _cursor += bytesPerSample;
  }

  void _header(int rate, int dataBytes) {
    _ascii('RIFF');
    _u32(_riffExtraBytes + dataBytes);
    _ascii('WAVE');
    _ascii('fmt ');
    _u32(_formatChunkBytes);
    _u16(_pcmFormat);
    _u16(_channels);
    _u32(rate);
    _u32(rate * _channels * bytesPerSample);
    _u16(_channels * bytesPerSample);
    _u16(bytesPerSample * _bitsPerByte);
    _ascii('data');
    _u32(dataBytes);
  }

  void _ascii(String text) {
    for (final unit in text.codeUnits) {
      _data.setUint8(_cursor++, unit);
    }
  }

  void _u16(int value) {
    _data.setUint16(_cursor, value, Endian.little);
    _cursor += _u16Size;
  }

  void _u32(int value) {
    _data.setUint32(_cursor, value, Endian.little);
    _cursor += _u32Size;
  }
}
