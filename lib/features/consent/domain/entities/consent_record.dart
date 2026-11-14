import 'package:equatable/equatable.dart';

import '../../../../core/consent/consent_policy.dart';
import '../../../../core/consent/consent_scope.dart';

class ConsentRecord extends Equatable {
  const ConsentRecord({this.granted = const {}, this.policyVersion});

  final Set<ConsentScope> granted;
  final String? policyVersion;

  bool get isCurrent => policyVersion == ConsentPolicy.version;

  bool allows(ConsentScope scope) => granted.contains(scope);

  ConsentRecord withDecision(
    ConsentScope scope, {
    required bool allowed,
    required bool complete,
  }) {
    final next = Set<ConsentScope>.of(granted);
    allowed ? next.add(scope) : next.remove(scope);
    return ConsentRecord(
      granted: Set.unmodifiable(next),
      policyVersion: complete || isCurrent
          ? ConsentPolicy.version
          : policyVersion,
    );
  }

  @override
  List<Object?> get props => [granted, policyVersion];
}
