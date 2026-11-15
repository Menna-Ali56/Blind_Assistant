import 'package:equatable/equatable.dart';

import '../../../../core/consent/consent_scope.dart';
import '../../domain/entities/consent_record.dart';

class ConsentState extends Equatable {
  const ConsentState({
    this.record = const ConsentRecord(),
    this.decided = const {},
    this.loaded = false,
  });

  final ConsentRecord record;
  final Set<ConsentScope> decided;
  final bool loaded;

  bool allows(ConsentScope scope) => record.allows(scope);

  ConsentScope? get pending {
    if (record.isCurrent) return null;
    return ConsentScope.values
        .where((scope) => !decided.contains(scope))
        .firstOrNull;
  }

  bool get isComplete => loaded && (record.isCurrent || pending == null);

  ConsentState copyWith({
    ConsentRecord? record,
    Set<ConsentScope>? decided,
    bool? loaded,
  }) {
    return ConsentState(
      record: record ?? this.record,
      decided: decided ?? this.decided,
      loaded: loaded ?? this.loaded,
    );
  }

  @override
  List<Object?> get props => [record, decided, loaded];
}
