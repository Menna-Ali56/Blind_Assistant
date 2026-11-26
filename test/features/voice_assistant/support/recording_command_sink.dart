import 'package:baseer/features/voice_assistant/spotter.dart';

class RecordingCommandSink implements CommandSink {
  RecordingCommandSink({this.failing = false});

  final bool failing;
  final List<ParsedCommand> commands = [];

  @override
  void onCommand(ParsedCommand command) {
    commands.add(command);
    if (failing) throw StateError('sink failed');
  }
}
