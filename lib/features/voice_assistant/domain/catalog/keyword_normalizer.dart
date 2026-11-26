abstract final class KeywordNormalizer {
  static final RegExp _marks = RegExp('[\u064B-\u065F\u0670]');
  static final RegExp _spaces = RegExp(r'\s+');
  static const String _space = ' ';
  static const Map<String, String> _letters = {
    '\u0623': '\u0627',
    '\u0625': '\u0627',
    '\u0622': '\u0627',
    '\u0649': '\u064A',
    '\u0629': '\u0647',
  };

  static String normalize(String raw) {
    var text = raw.toLowerCase().replaceAll(_marks, '');
    _letters.forEach((from, to) => text = text.replaceAll(from, to));
    return text.replaceAll(_spaces, _space).trim();
  }
}
