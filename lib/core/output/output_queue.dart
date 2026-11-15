import 'output_message.dart';

class QueuedOutput {
  const QueuedOutput(this.message, this.enqueuedAt);

  final OutputMessage message;
  final DateTime enqueuedAt;
}

class OutputQueue {
  final List<QueuedOutput> _items = [];

  int get length => _items.length;

  bool get isEmpty => _items.isEmpty;

  void add(OutputMessage message, DateTime at) {
    final item = QueuedOutput(message, at);
    final index = _items.indexWhere(
      (other) => other.message.priority.index < message.priority.index,
    );
    if (index == -1) {
      _items.add(item);
    } else {
      _items.insert(index, item);
    }
  }

  QueuedOutput removeFirst() => _items.removeAt(0);

  void removeWhere(bool Function(QueuedOutput item) test) =>
      _items.removeWhere(test);

  void trimTo(int max) {
    while (_items.length > max) {
      _items.removeLast();
    }
  }

  void clear() => _items.clear();
}
