import 'package:equatable/equatable.dart';

class CommandOutcome extends Equatable {
  const CommandOutcome({this.spoken});

  final String? spoken;

  @override
  List<Object?> get props => [spoken];
}
