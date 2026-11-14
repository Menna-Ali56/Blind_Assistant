import 'dart:async';

import 'package:baseer/core/output/output.dart';

class FakeChannel implements OutputChannel {
  FakeChannel({this.autoComplete = false});

  final bool autoComplete;
  final List<String> spoken = [];
  final List<OutputPriority> priorities = [];
  final List<OutputHaptic> haptics = [];
  final Map<String, Completer<void>> _gates = {};
  int stops = 0;

  @override
  Future<void> speak(
    String text, {
    required String languageCode,
    required OutputPriority priority,
  }) {
    spoken.add(text);
    priorities.add(priority);
    if (text == 'bad') throw StateError('speaker broke');
    if (autoComplete) return Future<void>.value();
    final gate = Completer<void>();
    _gates[text] = gate;
    return gate.future;
  }

  void finish(String text) => _gates.remove(text)?.complete();

  @override
  Future<void> stop() async => stops++;

  @override
  Future<void> haptic(OutputHaptic kind) async => haptics.add(kind);
}

class RecordingOutputChannel implements OutputChannel {
  final List<String> spoken = [];
  final List<OutputPriority> priorities = [];
  final List<OutputHaptic> haptics = [];
  int stops = 0;

  @override
  Future<void> speak(
    String text, {
    required String languageCode,
    required OutputPriority priority,
  }) async {
    spoken.add(text);
    priorities.add(priority);
  }

  @override
  Future<void> stop() async => stops++;

  @override
  Future<void> haptic(OutputHaptic kind) async => haptics.add(kind);
}

class FakeAudioFocus implements AudioFocus {
  final List<String> events = [];
  final StreamController<void> _interruptions =
      StreamController<void>.broadcast();

  void triggerInterruption() => _interruptions.add(null);

  @override
  Future<void> acquire() async => events.add('acquire');

  @override
  Future<void> release() async => events.add('release');

  @override
  Stream<void> get interruptions => _interruptions.stream;

  Future<void> close() => _interruptions.close();
}

OutputMessage msg(
  String text, {
  OutputPriority priority = OutputPriority.normal,
  String? key,
  String? ownerId,
  Duration? expiresAfter,
  OutputHaptic haptic = OutputHaptic.none,
}) => OutputMessage(
  text: text,
  languageCode: 'en',
  priority: priority,
  key: key,
  ownerId: ownerId,
  expiresAfter: expiresAfter,
  haptic: haptic,
);
