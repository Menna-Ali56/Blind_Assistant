import '../entities/voice_command.dart';

abstract interface class CommandProvider {
  List<VoiceCommand> get commands;
}
