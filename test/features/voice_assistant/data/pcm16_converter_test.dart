import 'dart:typed_data';

import 'package:baseer/features/voice_assistant/data/pcm16_converter.dart';
import 'package:baseer/features/voice_assistant/data/spotter_defaults.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('converts little endian samples to the unit range', () {
    final bytes = Uint8List.fromList([0x00, 0x00, 0x00, 0x40, 0x00, 0x80]);
    final samples = Pcm16Converter.toFloat(bytes);
    expect(samples, [0.0, 16384 / SpotterDefaults.pcmScale, -1.0]);
  });

  test('ignores a trailing odd byte', () {
    expect(Pcm16Converter.toFloat(Uint8List.fromList([0, 0, 1])).length, 1);
  });

  test('empty input gives empty output', () {
    expect(Pcm16Converter.toFloat(Uint8List(0)), isEmpty);
  });
}
