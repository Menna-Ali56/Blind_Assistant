import '../entities/parsed_command.dart';

abstract interface class CommandSink {
  void onCommand(ParsedCommand command);
}
