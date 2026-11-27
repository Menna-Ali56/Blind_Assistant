/// Speaks to the user and tells the state machine when it is quiet again.
abstract interface class SpokenReply {
  /// Completes when [text] (and anything queued before it) is finished or was
  /// cut off.
  Future<void> say(String text, {required String languageCode});

  /// Completes when nothing is being spoken or waiting to be spoken. Used to
  /// wait for an error announcement made by someone else.
  Future<void> whenIdle();

  /// Cuts off what this assistant is saying.
  Future<void> stop();
}
