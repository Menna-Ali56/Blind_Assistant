class ConfidenceTable {
  const ConfidenceTable(this._table, {required this.fallback});

  final Map<String, double> _table;
  final double fallback;

  double of(String id) => _table[id] ?? fallback;

  bool accepts(String id, double confidence) => confidence >= of(id);
}
