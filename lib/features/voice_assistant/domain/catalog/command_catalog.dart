import '../entities/command_locale.dart';
import 'catalog_entry.dart';
import 'keyword_normalizer.dart';

class KeywordGroup {
  const KeywordGroup({
    required this.id,
    required this.phrases,
    this.slots = const {},
  });

  final String id;
  final Map<CommandLocale, List<String>> phrases;
  final Map<String, String> slots;
}

class CommandCatalog {
  CommandCatalog(List<KeywordGroup> groups) : _index = _build(groups);

  final Map<String, CatalogEntry> _index;

  Iterable<CatalogEntry> get entries => _index.values;

  CatalogEntry? lookup(String keyword) =>
      _index[KeywordNormalizer.normalize(keyword)];

  static Map<String, CatalogEntry> _build(List<KeywordGroup> groups) {
    final index = <String, CatalogEntry>{};
    for (final group in groups) {
      for (final locale in group.phrases.entries) {
        for (final keyword in locale.value) {
          index.putIfAbsent(
            KeywordNormalizer.normalize(keyword),
            () => CatalogEntry(
              id: group.id,
              locale: locale.key,
              slots: group.slots,
            ),
          );
        }
      }
    }
    return index;
  }
}
