import 'package:vibration/vibration.dart';

import 'haptic_driver.dart';

class VibrationHapticDriver implements HapticDriver {
  const VibrationHapticDriver();

  @override
  Future<bool> get isAvailable async => (await Vibration.hasVibrator()) == true;

  @override
  Future<void> play({
    required List<int> timings,
    required List<int> amplitudes,
  }) => Vibration.vibrate(pattern: timings, intensities: amplitudes);

  @override
  Future<void> cancel() => Vibration.cancel();
}
