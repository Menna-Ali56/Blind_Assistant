import 'package:baseer/features/voice_assistant/spotter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const fallback = 0.5;
  final table = ConfidenceTable(SpotterLimits.thresholds, fallback: fallback);

  test('every command has its own threshold', () {
    for (final id in CommandKeywords.allIds) {
      expect(SpotterLimits.thresholds.containsKey(id), isTrue);
    }
  });

  test('thresholds stay inside zero and one', () {
    for (final value in SpotterLimits.thresholds.values) {
      expect(value, inInclusiveRange(0, 1));
      expect(value, greaterThan(0));
    }
  });

  test('a score at the threshold passes and below it is dropped', () {
    final value = SpotterLimits.thresholds[CommandKeywords.wakeId]!;
    expect(table.accepts(CommandKeywords.wakeId, value), isTrue);
    expect(table.accepts(CommandKeywords.wakeId, value - 0.01), isFalse);
  });

  test('a score that is not a number is dropped', () {
    expect(table.accepts(CommandKeywords.wakeId, double.nan), isFalse);
  });

  test('a missing command uses the fallback', () {
    const empty = ConfidenceTable({}, fallback: fallback);
    expect(empty.of(CommandKeywords.wakeId), fallback);
  });
}
