import 'package:equatable/equatable.dart';

class ParsedCommand extends Equatable {
  const ParsedCommand({required this.id, this.slots = const {}});

  final String id;
  final Map<String, String> slots;

  @override
  List<Object> get props => [id, slots];
}
