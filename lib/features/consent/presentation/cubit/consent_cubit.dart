import '../../../../core/accessibility/screen_reader_status.dart';
import '../../../../core/consent/consent_scope.dart';
import '../../../../core/consent/granted_consent.dart';
import '../../../../core/cubit/base_cubit.dart';
import '../../../../core/errors/handlers/error_logger.dart';
import '../../../../core/output/output.dart';
import '../../domain/entities/consent_record.dart';
import '../../domain/repositories/consent_remote.dart';
import '../../domain/repositories/consent_repository.dart';
import '../../domain/usecases/save_consent.dart';
import '../texts/consent_texts.dart';
import '../texts/consent_texts_lookup.dart';
import 'consent_state.dart';

class ConsentCubit extends BaseCubit<ConsentState> {
  ConsentCubit({
    required this.repository,
    required this.granted,
    required this.output,
    required this.languageCode,
    ConsentRemote remote = const NoConsentRemote(),
    this.screenReader = const PlatformScreenReaderStatus(),
    ErrorLogger logger = const ErrorLogger(),
  }) : _save = SaveConsent(repository, remote, logger: logger),
       super(const ConsentState());

  static const String ownerId = 'consent';

  final ConsentRepository repository;
  final GrantedConsent granted;
  final OutputCoordinator output;
  final String Function() languageCode;
  final ScreenReaderStatus screenReader;
  final SaveConsent _save;

  ConsentTexts get texts => consentTextsFor(languageCode());
  bool get needsDecision => !state.record.isCurrent;

  Future<void> load() async {
    final result = await repository.load();
    var record = const ConsentRecord();
    result.fold(
      onSuccess: (loaded) => record = loaded,
      onFailure: (f) =>
          _save.logger.log(f, StackTrace.current, context: ownerId),
    );
    granted.update(record.granted);
    safeEmit(ConsentState(record: record, loaded: true));
  }

  Future<bool> needsFlow() async {
    if (!state.loaded) await load();
    return needsDecision;
  }

  Future<void> decide(ConsentScope scope, {required bool allowed}) =>
      _applyScope(scope, allowed: allowed, finalize: false);
  Future<void> toggle(ConsentScope scope) =>
      _applyScope(scope, allowed: !state.allows(scope), finalize: true);
  void finish() => _say(texts.doneMessage);

  void reset() {
    const empty = ConsentRecord();
    granted.update(empty.granted);
    safeEmit(const ConsentState(record: empty, loaded: true));
  }

  void announce(ConsentScope scope) {
    if (!screenReader.isActive) _say(texts.announcement(scope));
  }

  Future<void> _applyScope(
    ConsentScope scope, {
    required bool allowed,
    required bool finalize,
  }) async {
    final nextDecided = {...state.decided, scope};
    final done = finalize || nextDecided.length == ConsentScope.values.length;
    final nextRecord = state.record.withDecision(
      scope,
      allowed: allowed,
      complete: done,
    );
    granted.update(nextRecord.granted);
    safeEmit(
      ConsentState(record: nextRecord, decided: nextDecided, loaded: true),
    );
    await _save(nextRecord);
  }

  void _say(String text) => output.submit(
    OutputMessage(
      text: text,
      languageCode: languageCode(),
      priority: OutputPriority.high,
      key: ownerId,
      ownerId: ownerId,
    ),
  );
}
