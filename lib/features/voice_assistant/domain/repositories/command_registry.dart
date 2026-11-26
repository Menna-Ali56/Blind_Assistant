import '../entities/voice_command.dart';
import 'command_provider.dart';

/// Every feature plugs its voice commands in here
class CommandRegistry {
  final Map<String, VoiceCommand> _commands = {};

  Iterable<String> get ids => _commands.keys;

  VoiceCommand? find(String id) => _commands[id];

  void add(CommandProvider provider) {
    final incoming = <String, VoiceCommand>{};
    for (final command in provider.commands) {
      if (_commands.containsKey(command.id) ||
          incoming.containsKey(command.id)) {
        throw ArgumentError.value(command.id, 'id', 'Already registered');
      }
      incoming[command.id] = command;
    }
    _commands.addAll(incoming);
  }
}
