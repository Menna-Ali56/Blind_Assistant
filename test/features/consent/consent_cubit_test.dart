import 'package:baseer/core/accessibility/screen_reader_status.dart';
import 'package:baseer/core/consent/consent.dart';
import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/core/output/output.dart';
import 'package:baseer/core/storage/storage.dart';
import 'package:baseer/features/consent/consent.dart';
import 'package:baseer/features/consent/data/repositories/consent_repository_impl.dart';
import 'package:baseer/features/consent/domain/repositories/consent_remote.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeConsentRemote implements ConsentRemote {
  final List<ConsentRecord> saved = [];
  bool throwError = false;
  Failure? failure;

  @override
  Future<Result<void>> save(ConsentRecord record) async {
    if (throwError) throw StateError('remote unavailable');
    if (failure != null) return ResultFailure<void>(failure!);
    saved.add(record);
    return const ResultSuccess<void>(null);
  }
}

class _FixedScreenReader implements ScreenReaderStatus {
  const _FixedScreenReader({this.isActive = false});

  @override
  final bool isActive;
}

class _RecordingChannel implements OutputChannel {
  final List<String> spoken = [];

  @override
  Future<void> speak(
    String text, {
    required String languageCode,
    required OutputPriority priority,
  }) async => spoken.add(text);

  @override
  Future<void> stop() async {}

  @override
  Future<void> haptic(OutputHaptic kind) async {}
}

void main() {
  late InMemorySecureStore store;
  late ConsentRepositoryImpl repository;
  late GrantedConsent granted;
  late _RecordingChannel channel;
  late _FakeConsentRemote remote;

  ConsentCubit makeCubit({
    ScreenReaderStatus reader = const _FixedScreenReader(),
  }) => ConsentCubit(
    repository: repository,
    granted: granted,
    output: OutputCoordinator(channel),
    languageCode: () => 'en',
    remote: remote,
    screenReader: reader,
  );

  setUp(() {
    store = InMemorySecureStore();
    repository = ConsentRepositoryImpl(store);
    granted = GrantedConsent();
    channel = _RecordingChannel();
    remote = _FakeConsentRemote();
  });

  test(
    'needsDecision is true when missing or outdated policy version',
    () async {
      final cubit = makeCubit();
      addTearDown(cubit.close);

      expect(await cubit.needsFlow(), isTrue);

      await repository.save(const ConsentRecord(policyVersion: '0'));
      await cubit.load();
      expect(cubit.needsDecision, isTrue);
    },
  );

  test(
    'deciding all scopes finalizes policyVersion and syncs remote',
    () async {
      final cubit = makeCubit();
      addTearDown(cubit.close);
      await cubit.load();

      await cubit.decide(ConsentScope.imageUpload, allowed: true);
      await cubit.decide(ConsentScope.audioUpload, allowed: false);
      expect(cubit.needsDecision, isTrue);

      await cubit.decide(ConsentScope.locationShare, allowed: true);

      expect(cubit.needsDecision, isFalse);
      expect(cubit.state.record.policyVersion, ConsentPolicy.version);
      expect(granted.allows(ConsentScope.imageUpload), isTrue);
      expect(granted.allows(ConsentScope.audioUpload), isFalse);
      expect(remote.saved.length, 3);
    },
  );

  test('local save succeeds even when ConsentRemote throws or fails', () async {
    remote.throwError = true;
    final cubit = makeCubit();
    addTearDown(cubit.close);

    await cubit.decide(ConsentScope.imageUpload, allowed: true);
    expect(granted.allows(ConsentScope.imageUpload), isTrue);

    remote.throwError = false;
    remote.failure = const NetworkFailure();
    await cubit.toggle(ConsentScope.imageUpload);
    expect(granted.allows(ConsentScope.imageUpload), isFalse);
  });

  test(
    'NoConsentRemote succeeds and announce respects screen reader',
    () async {
      const noOp = NoConsentRemote();
      expect(
        await noOp.save(const ConsentRecord()),
        isA<ResultSuccess<void>>(),
      );

      final quiet = makeCubit(reader: const _FixedScreenReader(isActive: true));
      addTearDown(quiet.close);
      quiet.announce(ConsentScope.imageUpload);
      await pumpEventQueue();
      expect(channel.spoken, isEmpty);
    },
  );
}
