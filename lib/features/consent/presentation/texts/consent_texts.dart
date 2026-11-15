import '../../../../core/consent/consent_scope.dart';

class ConsentTexts {
  const ConsentTexts({
    required this.labels,
    required this.purposes,
    required this.title,
    required this.allowAction,
    required this.notNowAction,
    required this.allowHint,
    required this.doneMessage,
  });

  final Map<ConsentScope, String> labels;
  final Map<ConsentScope, String> purposes;
  final String title;
  final String allowAction;
  final String notNowAction;
  final String allowHint;
  final String doneMessage;

  String label(ConsentScope scope) => labels[scope]!;

  String purpose(ConsentScope scope) => purposes[scope]!;

  String announcement(ConsentScope scope) =>
      '${label(scope)}. ${purpose(scope)} $allowHint';
}
