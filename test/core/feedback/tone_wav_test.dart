import 'dart:convert';
import 'dart:typed_data';

import 'package:baseer/core/feedback/earcon_catalog.dart';
import 'package:baseer/core/feedback/earcon_spec.dart';
import 'package:baseer/core/feedback/tone_wav.dart';
import 'package:baseer/core/feedback/wav_writer.dart';
import 'package:flutter_test/flutter_test.dart';

const _spec = EarconSpec(
  frequencyHz: 1000,
  tone: Duration(milliseconds: 100),
  gap: Duration(milliseconds: 50),
  volume: 0.5,
  repeat: 2,
);

int _count(Duration span) =>
    EarconCatalog.sampleRate * span.inMicroseconds ~/ 1000000;

void main() {
  final wav = ToneWav.encode(_spec);
  final data = ByteData.sublistView(wav);

  test('header describes mono pcm16 audio', () {
    expect(ascii.decode(wav.sublist(0, 4)), 'RIFF');
    expect(ascii.decode(wav.sublist(8, 12)), 'WAVE');
    expect(ascii.decode(wav.sublist(36, 40)), 'data');
    expect(data.getUint32(24, Endian.little), EarconCatalog.sampleRate);
    expect(data.getUint16(22, Endian.little), 1);
    expect(data.getUint16(34, Endian.little), 16);
  });

  test('length matches tones plus gaps', () {
    final samples = _count(_spec.tone) * 2 + _count(_spec.gap);
    final expected = WavWriter.headerBytes + samples * WavWriter.bytesPerSample;
    expect(wav.length, expected);
    expect(data.getUint32(40, Endian.little), samples * 2);
  });

  test('volume caps the peak and the gap is silent', () {
    final tone = _count(_spec.tone);
    var peak = 0;
    for (var i = 0; i < tone; i++) {
      final value = data.getInt16(WavWriter.headerBytes + i * 2, Endian.little);
      if (value.abs() > peak) peak = value.abs();
    }
    expect(peak, inInclusiveRange(1, (32767 * _spec.volume).round()));
    final gapStart = WavWriter.headerBytes + tone * 2;
    expect(data.getInt16(gapStart, Endian.little), 0);
  });
}
