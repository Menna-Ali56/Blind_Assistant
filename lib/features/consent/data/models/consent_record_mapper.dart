import '../../../../core/consent/consent_scope.dart';
import '../../domain/entities/consent_record.dart';

abstract final class ConsentRecordMapper {
  static const int schemaVersion = 1;

  static Map<String, Object?> toJson(ConsentRecord record) => {
    'version': schemaVersion,
    'policyVersion': record.policyVersion,
    'granted': [for (final scope in record.granted) scope.key],
  };

  static ConsentRecord fromJson(Map<String, Object?> json) {
    final version = json['policyVersion'];
    final policyVersion = version is String && version.isNotEmpty
        ? version
        : null;
    final raw = json['granted'];
    final granted = <ConsentScope>{};
    if (raw is List) {
      for (final item in raw) {
        final match = ConsentScope.values
            .where((scope) => scope.key == item)
            .firstOrNull;
        if (match != null) granted.add(match);
      }
    }
    return ConsentRecord(
      granted: Set.unmodifiable(granted),
      policyVersion: policyVersion,
    );
  }
}
