import 'dart:async';

import 'audio_focus.dart';
import 'output_channel.dart';
import 'output_message.dart';
import 'output_queue.dart';

class OutputCoordinator {
  OutputCoordinator(
    this._channel, {
    this.focus = const NoAudioFocus(),
    DateTime Function()? now,
    this.maxPending = defaultMaxPending,
    this.onChannelError,
  }) : _now = now ?? DateTime.now {
    _interruptionSub = focus.interruptions.listen(
      (_) => unawaited(stopCurrent()),
    );
  }

  static const int defaultMaxPending = 10;

  final OutputChannel _channel;
  final AudioFocus focus;
  final DateTime Function() _now;

  /// Waiting messages above this count are dropped, lowest priority first.
  final int maxPending;

  /// Called when the channel throws. The queue keeps going either way.
  final void Function(Object error, StackTrace stackTrace)? onChannelError;

  final OutputQueue _queue = OutputQueue();
  StreamSubscription<void>? _interruptionSub;
  OutputMessage? _current;
  Completer<void>? _stopSignal;
  Future<void>? _stopping;
  bool _hasFocus = false;
  bool _draining = false;
  bool _disposed = false;

  bool get isSpeaking => _current != null;

  int get pendingCount => _queue.length;

  void submit(OutputMessage message) {
    if (_disposed) return;
    final key = message.key;
    if (key != null) _queue.removeWhere((item) => item.message.key == key);
    _queue.add(message, _now());
    _queue.trimTo(maxPending);
    if (_shouldInterrupt(message)) unawaited(_interrupt());
    unawaited(_drain());
  }

  /// Stops what is being spoken now. The next waiting message goes on.
  Future<void> stopCurrent() => _interrupt();

  /// Drops everything that belongs to [ownerId], waiting or speaking.
  void cancelOwner(String ownerId) {
    _queue.removeWhere((item) => item.message.ownerId == ownerId);
    if (_current?.ownerId == ownerId) unawaited(_interrupt());
  }

  void clear() {
    _queue.clear();
    unawaited(_interrupt());
  }

  Future<void> dispose() async {
    _disposed = true;
    _queue.clear();
    await _interruptionSub?.cancel();
    _interruptionSub = null;
    await _interrupt();
    await _releaseFocus();
  }

  bool _shouldInterrupt(OutputMessage incoming) {
    final current = _current;
    if (current == null) return false;
    final sameTopic = incoming.key != null && incoming.key == current.key;
    return sameTopic || incoming.priority.interrupts(current.priority);
  }

  Future<void> _interrupt() {
    if (_current == null) return Future<void>.value();
    final signal = _stopSignal;
    if (signal != null && !signal.isCompleted) signal.complete();
    final stopping = _safe(_channel.stop);
    _stopping = stopping;
    return stopping;
  }

  Future<void> _drain() async {
    if (_draining) return;
    _draining = true;
    var played = false;
    try {
      while (!_disposed) {
        final next = _nextLive();
        if (next == null) break;
        played = true;
        await _play(next);
      }
    } finally {
      _draining = false;
    }
    if (played && (_queue.isEmpty || _disposed)) {
      await _releaseFocus();
    }
    if (!_disposed && !_queue.isEmpty) unawaited(_drain());
  }

  OutputMessage? _nextLive() {
    final now = _now();
    while (!_queue.isEmpty) {
      final item = _queue.removeFirst();
      final ttl = item.message.expiresAfter;
      if (ttl == null || now.difference(item.enqueuedAt) <= ttl) {
        return item.message;
      }
    }
    return null;
  }

  Future<void> _play(OutputMessage message) async {
    final signal = Completer<void>();
    _current = message;
    _stopSignal = signal;
    try {
      final pendingStop = _stopping;
      if (pendingStop != null) await pendingStop;
      if (signal.isCompleted) return;
      if (!_hasFocus) {
        _hasFocus = true;
        if (focus is! NoAudioFocus) await _safe(focus.acquire);
      }
      if (signal.isCompleted) return;
      if (message.haptic != OutputHaptic.none) {
        await _safe(() => _channel.haptic(message.haptic));
      }
      if (signal.isCompleted) return;
      final spoken = _safe(
        () => _channel.speak(
          message.text,
          languageCode: message.languageCode,
          priority: message.priority,
        ),
      );
      await Future.any<void>([spoken, signal.future]);
    } finally {
      _current = null;
      _stopSignal = null;
    }
  }

  Future<void> _releaseFocus() async {
    if (!_hasFocus) return;
    _hasFocus = false;
    if (focus is! NoAudioFocus) await _safe(focus.release);
  }

  // the output path must never throw
  Future<void> _safe(Future<void> Function() action) async {
    try {
      await action();
    } catch (error, stackTrace) {
      try {
        onChannelError?.call(error, stackTrace);
      } catch (_) {}
    }
  }
}
