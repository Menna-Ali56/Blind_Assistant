import 'package:baseer/features/voice_assistant/spotter.dart';

import 'fake_keyword_spotter.dart';
import 'recording_command_sink.dart';

String keywordFor(
  String id, [
  CommandLocale locale = CommandLocale.enUs,
  Map<String, String> slots = const {},
]) {
  final group = CommandKeywords.table.firstWhere(
    (g) => g.id == id && _sameSlots(g.slots, slots),
  );
  return group.phrases[locale]!.first;
}

bool _sameSlots(Map<String, String> a, Map<String, String> b) {
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (b[entry.key] != entry.value) return false;
  }
  return true;
}

class SpotterHarness {
  SpotterHarness({
    this.wakeWord = true,
    bool failOnStart = false,
    bool failingSink = false,
  }) : spotter = FakeKeywordSpotter(failOnStart: failOnStart),
       sink = RecordingCommandSink(failing: failingSink) {
    controller = SpotterController(
      spotter: spotter,
      sink: sink,
      catalog: CommandCatalog(CommandKeywords.table),
      thresholds: ConfidenceTable(
        SpotterLimits.thresholds,
        fallback: SpotterLimits.commandConfidence,
      ),
      wakeWordEnabled: () => wakeWord,
      gate: WakeGate(now: () => clock),
      onError: errors.add,
    );
  }

  static const double sure = 1.0;

  final FakeKeywordSpotter spotter;
  final RecordingCommandSink sink;
  final List<Object> errors = [];
  late final SpotterController controller;
  bool wakeWord;
  DateTime clock = DateTime(2026);

  void hear(
    String id, {
    double confidence = sure,
    CommandLocale locale = CommandLocale.enUs,
    Map<String, String> slots = const {},
  }) => spotter.emit(keywordFor(id, locale, slots), confidence);

  void pass(Duration duration) => clock = clock.add(duration);
}
