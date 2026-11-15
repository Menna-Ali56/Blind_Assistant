import '../../../../core/errors/result/result.dart';
import '../repositories/account_deletion_remote.dart';
import '../repositories/settings_repository.dart';

class DeleteUserData {
  const DeleteUserData(
    this._repository, {
    this._remote = const NoRemoteDeletion(),
  });

  final SettingsRepository _repository;
  final AccountDeletionRemote _remote;

  Future<Result<void>> call() async {
    final remoteResult = await _remote.request();
    return remoteResult.fold(
      onSuccess: (_) => _repository.deleteAll(),
      onFailure: ResultFailure<void>.new,
    );
  }
}
