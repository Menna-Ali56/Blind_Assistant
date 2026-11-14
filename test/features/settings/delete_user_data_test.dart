import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/features/settings/domain/entities/app_settings.dart';
import 'package:baseer/features/settings/domain/repositories/account_deletion_remote.dart';
import 'package:baseer/features/settings/domain/repositories/settings_repository.dart';
import 'package:baseer/features/settings/domain/usecases/delete_user_data.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemorySettingsRepository implements SettingsRepository {
  AppSettings stored = const AppSettings();
  int deletes = 0;

  @override
  Future<Result<AppSettings>> load() async =>
      ResultSuccess<AppSettings>(stored);

  @override
  Future<Result<void>> save(AppSettings settings) async {
    stored = settings;
    return const ResultSuccess<void>(null);
  }

  @override
  Future<Result<void>> deleteAll() async {
    deletes++;
    stored = const AppSettings();
    return const ResultSuccess<void>(null);
  }
}

class _FakeDeletionRemote implements AccountDeletionRemote {
  _FakeDeletionRemote(this.result);

  Result<void> result;
  int calls = 0;

  @override
  Future<Result<void>> request() async {
    calls++;
    return result;
  }
}

void main() {
  late _MemorySettingsRepository repository;

  setUp(() {
    repository = _MemorySettingsRepository()
      ..stored = const AppSettings(highContrast: true);
  });

  test('remote failure blocks local deletion and returns failure', () async {
    final remote = _FakeDeletionRemote(
      const ResultFailure<void>(NetworkFailure()),
    );
    final useCase = DeleteUserData(repository, remote: remote);

    final result = await useCase();

    expect(
      result,
      isA<ResultFailure<void>>().having(
        (r) => r.failure,
        'failure',
        isA<NetworkFailure>(),
      ),
    );
    expect(remote.calls, 1);
    expect(repository.deletes, 0);
    expect(repository.stored, const AppSettings(highContrast: true));
  });

  test('remote success proceeds with local repository deletion', () async {
    final remote = _FakeDeletionRemote(const ResultSuccess<void>(null));
    final useCase = DeleteUserData(repository, remote: remote);

    final result = await useCase();

    expect(result, isA<ResultSuccess<void>>());
    expect(remote.calls, 1);
    expect(repository.deletes, 1);
    expect(repository.stored, const AppSettings());
  });

  test('default NoRemoteDeletion deletes local data', () async {
    final useCase = DeleteUserData(repository);

    final result = await useCase();

    expect(result, isA<ResultSuccess<void>>());
    expect(repository.deletes, 1);
    expect(repository.stored, const AppSettings());
  });
}
