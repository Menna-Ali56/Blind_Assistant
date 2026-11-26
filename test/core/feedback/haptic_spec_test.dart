import 'package:baseer/core/feedback/feedback.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const spec = HapticSpec([
    HapticPulse(10, 20),
    HapticPulse(30),
  ], strength: 0.5);

  test('timings start with a zero wait then alternate', () {
    expect(spec.timings, [0, 10, 20, 30, 0]);
  });

  test('amplitudes follow the timings and scale with intensity', () {
    expect(spec.amplitudes(HapticIntensity.medium), [0, 80, 0, 80, 0]);
    expect(spec.amplitudes(HapticIntensity.high), [0, 128, 0, 128, 0]);
  });

  test('amplitude never drops below one', () {
    const faint = HapticSpec([HapticPulse(10)], strength: 0);
    expect(faint.amplitudes(HapticIntensity.low), [0, 1, 0]);
  });
}
