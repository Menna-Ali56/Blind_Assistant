import 'dart:async';

import '../../../../core/errors/errors.dart';
import '../../../../core/output/output.dart';
import '../../presentation/texts/voice_assistant_texts_lookup.dart';
import '../entities/parsed_command.dart';
import 'command_registry.dart';
import 'command_sink.dart';

class CommandRouter implements CommandSink {
  CommandRouter({
    required this._registry,
    required this._output,
    required this._supervisor,
    this._languageCode = defaultLanguageCode,
  });

  static const String reportSource = 'voice_command';
  static const String unknownKey = 'voice_command_unknown';
  static const String keyPrefix = 'voice_command_';
  static const String ownerId = 'voice_assistant';

  final CommandRegistry _registry;
  final OutputCoordinator _output;
  final ErrorSupervisor _supervisor;
  final String Function() _languageCode;

  @override
  void onCommand(ParsedCommand command) => unawaited(_handle(command));

  Future<void> _handle(ParsedCommand parsed) async {
    try {
      final command = _registry.find(parsed.id);
      if (command == null) {
        final texts = voiceAssistantTextsFor(_languageCode());
        _speak(unknownKey, texts.notUnderstood);
        return;
      }
      final outcome = await command.run(parsed.slots);
      final spoken = outcome.spoken;
      if (spoken != null) _speak('$keyPrefix${parsed.id}', spoken);
    } catch (error, stackTrace) {
      _report(error, stackTrace);
    }
  }

  void _speak(String key, String text) => _output.submit(
    OutputMessage(
      text: text,
      languageCode: _languageCode(),
      key: key,
      ownerId: ownerId,
    ),
  );

  void _report(Object error, StackTrace stackTrace) {
    try {
      _supervisor.report(error, stackTrace: stackTrace, source: reportSource);
    } catch (_) {}
  }
}
