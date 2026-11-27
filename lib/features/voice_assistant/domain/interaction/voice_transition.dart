import 'package:equatable/equatable.dart';

import 'voice_effect.dart';
import 'voice_interaction_state.dart';

class VoiceTransition extends Equatable {
  const VoiceTransition(this.state, [this.effects = const []]);

  final VoiceInteractionState state;

  /// Run in order, one after the other.
  final List<VoiceEffect> effects;

  @override
  List<Object> get props => [state, effects];
}
