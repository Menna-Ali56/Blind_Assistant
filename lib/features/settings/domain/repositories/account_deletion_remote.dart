import '../../../../core/errors/result/result.dart';

abstract interface class AccountDeletionRemote {
  Future<Result<void>> request();
}

class NoRemoteDeletion implements AccountDeletionRemote {
  const NoRemoteDeletion();

  @override
  Future<Result<void>> request() async => const ResultSuccess<void>(null);
}
