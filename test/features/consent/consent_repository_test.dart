import 'package:baseer/core/consent/consent.dart';
import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/core/storage/storage.dart';
import 'package:baseer/features/consent/consent.dart';
import 'package:baseer/features/consent/data/repositories/consent_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class _ThrowingStore implements SecureStore {
  @override
  Future<String?> read(String key) async => throw const StorageException();

  @override
  Future<void> write(String key, String value) async =>
      throw const StorageException();

  @override
  Future<void> delete(String key) async => throw const StorageException();

  @override
  Future<void> deleteAll() async => throw const StorageException();
}

ConsentRecord? _dataOf(Result<ConsentRecord> result) =>
    result.fold(onSuccess: (data) => data, onFailure: (_) => null);

Failure? _failureOf(Result<Object?> result) =>
    result.fold(onSuccess: (_) => null, onFailure: (failure) => failure);

void main() {
  late InMemorySecureStore store;
  late ConsentRepositoryImpl repository;

  setUp(() {
    store = InMemorySecureStore();
    repository = ConsentRepositoryImpl(store);
  });

  test('empty store defaults to non-current empty record', () async {
    final loaded = _dataOf(await repository.load());

    expect(loaded, const ConsentRecord());
    expect(loaded?.isCurrent, isFalse);
  });

  test('saved consent record loads back identically', () async {
    const record = ConsentRecord(
      granted: {ConsentScope.imageUpload, ConsentScope.locationShare},
      policyVersion: ConsentPolicy.version,
    );

    await repository.save(record);
    final loaded = _dataOf(await repository.load());

    expect(loaded, record);
    expect(loaded?.isCurrent, isTrue);
  });

  test('corrupt stored json falls back to default record', () async {
    await store.write(ConsentRepositoryImpl.storageKey, '{corrupt');

    expect(_dataOf(await repository.load()), const ConsentRecord());
  });

  test('clear removes saved consent record', () async {
    await repository.save(
      const ConsentRecord(
        granted: {ConsentScope.audioUpload},
        policyVersion: ConsentPolicy.version,
      ),
    );

    await repository.clear();

    expect(_dataOf(await repository.load()), const ConsentRecord());
  });

  test('storage failure propagates as StorageFailure', () async {
    final broken = ConsentRepositoryImpl(_ThrowingStore());

    expect(_failureOf(await broken.load()), isA<StorageFailure>());
    expect(
      _failureOf(await broken.save(const ConsentRecord())),
      isA<StorageFailure>(),
    );
    expect(_failureOf(await broken.clear()), isA<StorageFailure>());
  });
}
