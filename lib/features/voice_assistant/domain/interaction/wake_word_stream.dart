import '../../data/catalog/command_keywords.dart';
import '../catalog/command_catalog.dart';
import '../catalog/confidence_table.dart';
import '../repositories/keyword_spotter.dart';

/// One event each time the wake phrase is heard with enough confidence.
///
/// Listens to the same spotter as `SpotterController`. That controller keeps
/// the phrase to itself (it only opens its wake window), so the state machine
/// needs its own view of it.
Stream<void> wakeWordsOf(
  KeywordSpotter spotter, {
  required CommandCatalog catalog,
  required ConfidenceTable thresholds,
}) => spotter.events
    .where((event) {
      final entry = catalog.lookup(event.keyword);
      return entry != null &&
          entry.id == CommandKeywords.wakeId &&
          thresholds.accepts(entry.id, event.confidence);
    })
    .map<void>((_) {});
