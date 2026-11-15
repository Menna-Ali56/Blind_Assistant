import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'connectivity_monitor.dart';

class ConnectivityPlusMonitor implements ConnectivityMonitor {
  ConnectivityPlusMonitor([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  final StreamController<bool> _changes = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _online = false;

  @override
  bool get isOnline => _online;

  @override
  Stream<bool> get changes => _changes.stream;

  @override
  Future<void> start() async {
    _update(await _connectivity.checkConnectivity());
    _subscription ??= _connectivity.onConnectivityChanged.listen(_update);
  }

  @override
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  void _update(List<ConnectivityResult> results) {
    final online = results.any((item) => item != ConnectivityResult.none);
    final changed = online != _online;
    _online = online;
    if (changed && !_changes.isClosed) _changes.add(online);
  }
}
