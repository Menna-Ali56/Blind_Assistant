import 'package:equatable/equatable.dart';

import 'haptic_intensity.dart';

class HapticPulse extends Equatable {
  const HapticPulse(this.onMs, [this.gapMs = 0]);

  final int onMs;
  final int gapMs;

  @override
  List<Object> get props => [onMs, gapMs];
}

class HapticSpec extends Equatable {
  const HapticSpec(this.pulses, {this.strength = 1.0});

  final List<HapticPulse> pulses;
  final double strength;

  List<int> get timings => [
    0,
    for (final pulse in pulses) ...[pulse.onMs, pulse.gapMs],
  ];

  List<int> amplitudes(HapticIntensity intensity) {
    final level = (intensity.amplitude * strength)
        .round()
        .clamp(1, HapticIntensity.maxAmplitude)
        .toInt();
    return [
      0,
      for (final _ in pulses) ...[level, 0],
    ];
  }

  @override
  List<Object> get props => [pulses, strength];
}
