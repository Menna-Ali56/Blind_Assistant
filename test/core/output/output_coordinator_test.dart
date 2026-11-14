import 'dart:async';

import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/core/output/output.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeChannel implements OutputChannel {
  FakeChannel({this.autoComplete = false});

  final bool autoComplete;
  final List<String> spoken = [];
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

void main() {
  late DateTime clock;

  setUp(() => clock = DateTime(2026));

  group('OutputCoordinator', () {
    test('speaks in arrival order inside one priority', () async {
      final channel = FakeChannel(autoComplete: true);
      final coordinator = OutputCoordinator(channel);

      coordinator
        ..submit(msg('a'))
        ..submit(msg('b'));
      await pumpEventQueue();

      expect(channel.spoken, ['a', 'b']);
    });

    test('a more urgent waiting message goes first', () async {
      final channel = FakeChannel();
      final coordinator = OutputCoordinator(channel);

      coordinator
        ..submit(msg('first'))
        ..submit(msg('low', priority: OutputPriority.low))
        ..submit(msg('second'));
      channel.finish('first');
      await pumpEventQueue();

      expect(channel.spoken, ['first', 'second']);
    });

    test('a higher priority message interrupts the current one', () async {
      final channel = FakeChannel();
      final coordinator = OutputCoordinator(channel);

      coordinator
        ..submit(msg('info'))
        ..submit(msg('alert', priority: OutputPriority.critical));
      await pumpEventQueue();

      expect(channel.stops, 1);
      expect(channel.spoken, ['info', 'alert']);
    });

    test('the same priority does not interrupt', () async {
      final channel = FakeChannel();
      final coordinator = OutputCoordinator(channel);

      coordinator
        ..submit(msg('a'))
        ..submit(msg('b'));
      await pumpEventQueue();

      expect(channel.stops, 0);
      expect(channel.spoken, ['a']);
    });

    test('a message with the same key replaces the waiting one', () async {
      final channel = FakeChannel();
      final coordinator = OutputCoordinator(channel);

      coordinator
        ..submit(msg('a'))
        ..submit(msg('old', key: 'distance'))
        ..submit(msg('new', key: 'distance'));
      channel.finish('a');
      await pumpEventQueue();

      expect(channel.spoken, ['a', 'new']);
    });

    test('cancelOwner drops waiting messages and stops the current', () async {
      final channel = FakeChannel();
      final coordinator = OutputCoordinator(channel);

      coordinator
        ..submit(msg('a', ownerId: 't1'))
        ..submit(msg('b', ownerId: 't1'))
        ..submit(msg('c', ownerId: 't2'))
        ..cancelOwner('t1');
      await pumpEventQueue();

      expect(channel.stops, 1);
      expect(channel.spoken, ['a', 'c']);
    });

    test('stale messages are skipped', () async {
      final channel = FakeChannel();
      final coordinator = OutputCoordinator(channel, now: () => clock);

      coordinator
        ..submit(msg('a'))
        ..submit(msg('old', expiresAfter: const Duration(seconds: 5)));
      clock = clock.add(const Duration(seconds: 10));
      channel.finish('a');
      await pumpEventQueue();

      expect(channel.spoken, ['a']);
    });

    test('a failing channel does not stop the queue', () async {
      final channel = FakeChannel(autoComplete: true);
      var errors = 0;
      final coordinator = OutputCoordinator(
        channel,
        onChannelError: (_, _) => errors++,
      );

      coordinator
        ..submit(msg('bad'))
        ..submit(msg('good'));
      await pumpEventQueue();

      expect(channel.spoken, ['bad', 'good']);
      expect(errors, 1);
    });

    test('haptic feedback comes with the message', () async {
      final channel = FakeChannel(autoComplete: true);
      final coordinator = OutputCoordinator(channel);

      coordinator.submit(msg('a', haptic: OutputHaptic.heavy));
      await pumpEventQueue();

      expect(channel.haptics, [OutputHaptic.heavy]);
    });

    test('too many waiting messages are trimmed', () async {
      final channel = FakeChannel();
      final coordinator = OutputCoordinator(channel, maxPending: 2);

      coordinator.submit(msg('now'));
      for (var i = 0; i < 5; i++) {
        coordinator.submit(msg('m$i'));
      }

      expect(coordinator.pendingCount, 2);
    });
  });

  group('ErrorOutputBridge', () {
    test('speaks announced errors and ignores silent ones', () async {
      final channel = FakeChannel(autoComplete: true);
      final coordinator = OutputCoordinator(channel);
      final supervisor = ErrorSupervisor(now: () => clock);
      final bridge = ErrorOutputBridge(
        supervisor: supervisor,
        coordinator: coordinator,
        languageCode: () => 'en',
      )..start();

      supervisor
        ..reportFailure(const CancelledFailure())
        ..reportFailure(const NetworkFailure());
      await pumpEventQueue();

      expect(channel.spoken, hasLength(1));
      expect(channel.spoken.single, contains('internet'));
      expect(channel.haptics, [OutputHaptic.light]);

      await bridge.stop();
      await supervisor.dispose();
    });
  });
}
