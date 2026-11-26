import 'package:baseer/core/feedback/earcon_catalog.dart';
import 'package:baseer/core/feedback/earcon_player.dart';
import 'package:baseer/core/feedback/feedback_cue.dart';
import 'package:flutter_test/flutter_test.dart';

import '../output/output_test_support.dart';
import 'feedback_test_support.dart';

void main() {
  late FakeEarconDriver driver;
  late FakeAudioFocus focus;
  late List<Object> errors;
  var enabled = true;

  EarconPlayer build({FakeEarconDriver? custom, bool Function()? gate}) {
    return EarconPlayer(
      driver: custom ?? driver,
      focus: focus,
      isEnabled: gate ?? () => enabled,
      onError: (error, _) => errors.add(error),
    );
  }

  setUp(() {
    driver = FakeEarconDriver();
    focus = FakeAudioFocus();
    errors = [];
    enabled = true;
  });

  test('plays the catalog tone inside a focus window', () async {
    await build().play(FeedbackCue.done);
    expect(driver.played.length, 1);
    expect(driver.lengths.single, EarconCatalog.of(FeedbackCue.done).total);
    expect(focus.events, ['acquire', 'release']);
  });

  test('stays silent when disabled', () async {
    enabled = false;
    await build().play(FeedbackCue.done);
    expect(driver.played, isEmpty);
    expect(focus.events, isEmpty);
  });

  test('driver failure is reported and focus is released', () async {
    final player = build(custom: FakeEarconDriver(fails: true));
    await player.play(FeedbackCue.error);
    expect(errors.length, 1);
    expect(focus.events, ['acquire', 'release']);
  });

  test('a throwing gate never escapes', () async {
    await build(gate: () => throw StateError('gate')).play(FeedbackCue.done);
    expect(errors.length, 1);
  });

  test('same cue reuses the same bytes', () async {
    final player = build();
    await player.play(FeedbackCue.listening);
    await player.play(FeedbackCue.listening);
    expect(identical(driver.played.first, driver.played.last), isTrue);
  });

  test('cancel stops the driver', () async {
    await build().cancel();
    expect(driver.stops, 1);
  });
}
