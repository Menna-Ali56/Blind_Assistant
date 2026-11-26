import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/core/output/output.dart';
import 'package:baseer/features/voice_assistant/voice_assistant.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../core/output/output_test_support.dart';

class FakeProvider implements CommandProvider {
  const FakeProvider(this.commands);

  @override
  final List<VoiceCommand> commands;
}

VoiceCommand fakeCommand(String id, {String? spoken, Object? error}) =>
    VoiceCommand(
      id: id,
      run: (_) async {
        if (error != null) throw error;
        return CommandOutcome(spoken: spoken);
      },
    );

class RouterRig {
  RouterRig({String language = 'en', FakeChannel? channel})
    : channel = channel ?? FakeChannel(autoComplete: true) {
    router = CommandRouter(
      registry: registry,
      output: output,
      supervisor: supervisor,
      languageCode: () => language,
    );
  }

  final CommandRegistry registry = CommandRegistry();
  final FakeChannel channel;
  final ErrorSupervisor supervisor = ErrorSupervisor();
  late final OutputCoordinator output = OutputCoordinator(channel);
  late final CommandRouter router;

  void add(VoiceCommand command) => registry.add(FakeProvider([command]));

  Future<void> send(String id) async {
    router.onCommand(ParsedCommand(id: id));
    await pumpEventQueue();
  }
}
