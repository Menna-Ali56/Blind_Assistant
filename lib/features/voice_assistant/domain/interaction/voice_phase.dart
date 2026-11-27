/// Where the assistant is in one conversation turn.
///
/// ```
/// idle ──wake / tap──▶ listening ──audio──▶ processing ──reply──▶ speaking ──▶ idle
/// ```
enum VoicePhase {
  /// Nothing is happening. When standby is on, the wake word spotter owns the
  /// microphone; otherwise the microphone is free.
  idle,

  /// The user is being recorded.
  listening,

  /// The recording is being turned into an answer.
  processing,

  /// The answer (or an error) is being spoken.
  speaking,
}
