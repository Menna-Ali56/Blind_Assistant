import 'command_outcome.dart';

class VoiceCommand {
  const VoiceCommand({required this.id, required this.run});

  final String id;
  final Future<CommandOutcome> Function(Map<String, String> slots) run;
}
