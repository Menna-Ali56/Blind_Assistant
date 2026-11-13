import 'package:baseer/core/constants/app_defaults.dart';
import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/core/storage/storage.dart';
import 'package:baseer/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:baseer/features/settings/domain/entities/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

class ThrowingStore implements SecureStore {
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

AppSettings? dataOf(Result<AppSettings> result) =>
    result.fold(onSuccess: (data) => data, onFailure: (_) => null);

Failure? failureOf(Result<Object?> result) =>
    result.fold(onSuccess: (_) => null, onFailure: (failure) => failure);

void main() {
  late InMemorySecureStore store;
  late SettingsRepositoryImpl repository;

  setUp(() {
    store = InMemorySecureStore();
    repository = SettingsRepositoryImpl(store);
  });

  test('loads the defaults when nothing was saved', () async {
    expect(dataOf(await repository.load()), const AppSettings());
  });

  test('saved settings load back the same', () async {
    const saved = AppSettings(
      voiceRate: VoiceRate.fast,
      textScale: 1.5,
      highContrast: true,
      haptics: false,
      wakeWord: false,
      allowImageUpload: true,
    );

    await repository.save(saved);

    expect(dataOf(await repository.load()), saved);
  });

  test('damaged saved data loads the defaults', () async {
    await store.write(SettingsRepositoryImpl.storageKey, '{broken');

    expect(dataOf(await repository.load()), const AppSettings());
  });

  test('an out of range text scale is clamped', () async {
    await store.writeJson(SettingsRepositoryImpl.storageKey, {
      'textScale': 9.0,
    });

    final loaded = dataOf(await repository.load());

    expect(loaded?.textScale, AppDefaults.maxTextScale);
  });

  test('unknown values fall back to the defaults', () async {
    await store.writeJson(SettingsRepositoryImpl.storageKey, {
      'voiceRate': 'warp',
      'haptics': 'yes',
      'somethingNew': 1,
    });

    expect(dataOf(await repository.load()), const AppSettings());
  });

  test('deleteAll removes the saved settings', () async {
    await repository.save(const AppSettings(highContrast: true));

    await repository.deleteAll();

    expect(dataOf(await repository.load()), const AppSettings());
  });

  test('a storage error becomes a StorageFailure', () async {
    final broken = SettingsRepositoryImpl(ThrowingStore());

    expect(failureOf(await broken.load()), isA<StorageFailure>());
    expect(
      failureOf(await broken.save(const AppSettings())),
      isA<StorageFailure>(),
    );
  });
}
