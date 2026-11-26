import 'package:baseer/core/feedback/feedback.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeHapticDriver implements HapticDriver {
  bool available = true;
  bool failing = false;
  int availabilityChecks = 0;
  int cancels = 0;
  final List<List<int>> timingsPlayed = [];

  @override
  Future<bool> get isAvailable async {
    availabilityChecks++;
    return available;
  }

  @override
  Future<void> play({
    required List<int> timings,
    required List<int> amplitudes,
  }) async {
    if (failing) throw StateError('motor broke');
    timingsPlayed.add(timings);
  }

  @override
  Future<void> cancel() async => cancels++;
}

void main() {
  late FakeHapticDriver driver;

  setUp(() => driver = FakeHapticDriver());

  test('plays the catalog pattern of the cue', () async {
    await HapticPlayer(driver: driver).play(FeedbackCue.done);
    expect(driver.timingsPlayed, [hapticCatalog[FeedbackCue.done]!.timings]);
  });

  test('stays silent when haptics are switched off', () async {
    final player = HapticPlayer(driver: driver, isEnabled: () => false);
    await player.play(FeedbackCue.error);
    expect(driver.timingsPlayed, isEmpty);
  });

  test('stays silent when the device has no vibrator', () async {
    driver.available = false;
    await HapticPlayer(driver: driver).play(FeedbackCue.error);
    expect(driver.timingsPlayed, isEmpty);
  });

  test('checks availability only once', () async {
    final player = HapticPlayer(driver: driver);
    await player.play(FeedbackCue.done);
    await player.play(FeedbackCue.error);
    expect(driver.availabilityChecks, 1);
  });

  test('reports driver errors and never throws', () async {
    driver.failing = true;
    final errors = <Object>[];
    final player = HapticPlayer(
      driver: driver,
      onError: (error, _) => errors.add(error),
    );
    await player.play(FeedbackCue.warningEmergency);
    expect(errors, hasLength(1));
  });

  test('cancel reaches the driver', () async {
    await HapticPlayer(driver: driver).cancel();
    expect(driver.cancels, 1);
  });
}
