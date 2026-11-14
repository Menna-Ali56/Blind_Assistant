import 'dart:async';

import 'package:baseer/core/network/connectivity_monitor.dart';

class FakeConnectivityMonitor implements ConnectivityMonitor {
  FakeConnectivityMonitor({bool initialOnline = false})
    : _online = initialOnline;

  final StreamController<bool> _changes = StreamController<bool>.broadcast();
  bool _online;

  @override
  bool get isOnline => _online;

  @override
  Stream<bool> get changes => _changes.stream;

  void setOnline(bool value) {
    if (_online == value) return;
    _online = value;
    if (!_changes.isClosed) _changes.add(value);
  }

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() => _changes.close();
}
