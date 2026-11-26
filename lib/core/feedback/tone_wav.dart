import 'dart:math' as math;
import 'dart:typed_data';

import 'earcon_catalog.dart';
import 'earcon_spec.dart';
import 'wav_writer.dart';

abstract final class ToneWav {
  static const int _peak = 32767;
  static const double _twoPi = 2 * math.pi;

  static Uint8List encode(EarconSpec spec) {
    const rate = EarconCatalog.sampleRate;
    final samples = _samples(spec, rate);
    final writer = WavWriter(rate: rate, sampleCount: samples.length);
    for (final value in samples) {
      writer.sample(value);
    }
    return writer.bytes;
  }

  static Int16List _samples(EarconSpec spec, int rate) {
    final tone = _count(spec.tone, rate);
    final gap = _count(spec.gap, rate);
    final out = Int16List(tone * spec.repeat + gap * (spec.repeat - 1));
    for (var round = 0; round < spec.repeat; round++) {
      final start = round * (tone + gap);
      for (var i = 0; i < tone; i++) {
        out[start + i] = _value(spec, i, tone, rate);
      }
    }
    return out;
  }

  static int _value(EarconSpec spec, int index, int tone, int rate) {
    final fade = _count(EarconCatalog.fade, rate);
    final edge = math.min(index + 1, tone - index);
    final envelope = math.min(1.0, edge / fade);
    final wave = math.sin(_twoPi * spec.frequencyHz * index / rate);
    return (wave * envelope * spec.volume * _peak).round();
  }

  static int _count(Duration span, int rate) =>
      rate * span.inMicroseconds ~/ Duration.microsecondsPerSecond;
}
