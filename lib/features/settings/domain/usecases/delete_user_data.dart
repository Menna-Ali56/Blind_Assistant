
import '../../../../core/errors/result/result.dart';
import '../repositories/settings_repository.dart';

class DeleteUserData {
  const DeleteUserData(this._repository);

  final SettingsRepository _repository;

  Future<Result<void>> call() => _repository.deleteAll();
}
