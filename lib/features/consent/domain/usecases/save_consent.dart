import '../../../../core/errors/handlers/error_logger.dart';
import '../../../../core/errors/handlers/remote_sync_guard.dart';
import '../entities/consent_record.dart';
import '../repositories/consent_remote.dart';
import '../repositories/consent_repository.dart';

class SaveConsent {
  const SaveConsent(
    this._repository,
    this._remote, {
    this.logger = const ErrorLogger(),
  });

  static const String _syncContext = 'consent_sync';

  final ConsentRepository _repository;
  final ConsentRemote _remote;
  final ErrorLogger logger;

  Future<void> call(ConsentRecord record) async {
    await _repository.save(record);
    await runRemoteSync(
      () => _remote.save(record),
      context: _syncContext,
      logger: logger,
    );
  }
}
