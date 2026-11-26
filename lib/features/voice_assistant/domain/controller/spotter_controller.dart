import 'dart:async';

import '../catalog/command_catalog.dart';
import '../catalog/confidence_table.dart';
import '../entities/parsed_command.dart';
import '../entities/spotter_event.dart';
import '../repositories/command_sink.dart';
import '../repositories/keyword_spotter.dart';
import 'wake_gate.dart';

class SpotterController {
  SpotterController({
    required this._spotter,
    required this._sink,
    required this._catalog,
    required this._thresholds,
    required this._wakeWordEnabled,
    required this._gate,
    this._onError,
  });

  final KeywordSpotter _spotter;
  final CommandSink _sink;
  final CommandCatalog _catalog;
  final ConfidenceTable _thresholds;
  final bool Function() _wakeWordEnabled;
  final WakeGate _gate;
  final void Function(Object error)? _onError;

  StreamSubscription<SpotterEvent>? _subscription;

  Future<void> start() async {
    if (_subscription != null) return;
    try {
      _subscription = _spotter.events.listen(_handle, onError: _report);
      await _spotter.start();
    } on Object catch (error) {
      _report(error);
      await _release();
    }
  }

  Future<void> stop() async {
    await _release();
    await _guard(_spotter.stop);
  }

  Future<void> dispose() => stop();

  Future<void> _release() async {
    final subscription = _subscription;
    _subscription = null;
    _gate.close();
    await _guard(() async => subscription?.cancel());
  }

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on Object catch (error) {
      _report(error);
    }
  }

  void _handle(SpotterEvent event) {
    try {
      final command = _accept(event);
      if (command != null) _sink.onCommand(command);
    } on Object catch (error) {
      _report(error);
    }
  }

  ParsedCommand? _accept(SpotterEvent event) {
    final entry = _catalog.lookup(event.keyword);
    if (entry == null) return null;
    if (!_thresholds.accepts(entry.id, event.confidence)) return null;
    if (!_gate.admit(entry.id, enabled: _wakeWordEnabled())) return null;
    return ParsedCommand(id: entry.id, slots: entry.resolvedSlots);
  }

  void _report(Object error) {
    try {
      _onError?.call(error);
    } on Object catch (_) {
      return;
    }
  }
}
