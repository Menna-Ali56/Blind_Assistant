class SerialQueue {
  Future<void> _tail = Future.value();

  Future<void> run(Future<void> Function() action) {
    final job = _tail.then((_) => action());
    _tail = job.then<void>((_) {}, onError: (_) {});
    return job;
  }
}
