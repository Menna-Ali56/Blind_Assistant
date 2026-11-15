abstract interface class ConnectivityMonitor {
  bool get isOnline;

  Stream<bool> get changes;

  Future<void> start();

  Future<void> stop();
}
