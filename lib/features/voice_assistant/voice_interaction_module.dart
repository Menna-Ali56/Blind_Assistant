import 'package:get_it/get_it.dart';

import '../../core/audio/utterance_recorder.dart';
import '../../core/di/cubit_registration.dart';
import '../../core/di/di_module.dart';
import '../../core/errors/errors.dart';
import '../../core/feedback/cue_output.dart';
import '../../core/feedback/no_cue_output.dart';
import '../../core/output/output.dart';
import '../../core/tasks/task_controller.dart';
import '../settings/presentation/cubit/settings_cubit.dart';
import 'data/catalog/command_keywords.dart';
import 'data/interaction/output_spoken_reply.dart';
import 'domain/catalog/command_catalog.dart';
import 'domain/catalog/confidence_table.dart';
import 'domain/catalog/spotter_limits.dart';
import 'domain/controller/spotter_controller.dart';
import 'domain/interaction/spoken_reply.dart';
import 'domain/interaction/spotter_standby_control.dart';
import 'domain/interaction/standby_control.dart';
import 'domain/interaction/utterance_processor.dart';
import 'domain/interaction/wake_word_stream.dart';
import 'domain/repositories/keyword_spotter.dart';
import 'presentation/cubit/voice_interaction_cubit.dart';

class VoiceInteractionModule implements DiModule {
  const VoiceInteractionModule({this.languageCode = defaultLanguageCode});

  final String Function() languageCode;

  @override
  void register(GetIt locator) {
    if (!locator.isRegistered<UtteranceProcessor>()) {
      locator.registerLazySingleton<UtteranceProcessor>(
        UnavailableUtteranceProcessor.new,
      );
    }
    locator
      ..registerLazySingleton<SpokenReply>(
        () => OutputSpokenReply(locator<OutputCoordinator>()),
      )
      ..registerLazySingleton<StandbyControl>(
        () => SpotterStandbyControl(locator<SpotterController>()),
      )
      ..registerSharedCubit<VoiceInteractionCubit>(
        (_) => VoiceInteractionCubit(
          standby: locator<StandbyControl>(),
          speech: locator<SpokenReply>(),
          cues: locator.isRegistered<CueOutput>()
              ? locator<CueOutput>()
              : const NoCueOutput(),
          tasks: locator<TaskController>(),
          processor: locator<UtteranceProcessor>(),
          newRecorder: () => locator<UtteranceRecorder>(),
          supervisor: locator<ErrorSupervisor>(),
          languageCode: languageCode,
          wakeWords: wakeWordsOf(
            locator<KeywordSpotter>(),
            catalog: CommandCatalog(CommandKeywords.table),
            thresholds: ConfidenceTable(
              SpotterLimits.thresholds,
              fallback: SpotterLimits.commandConfidence,
            ),
          ),
          interruptions: locator<AudioFocus>().interruptions,
          wakeWordEnabled: () =>
              locator<SettingsCubit>().state.settings.wakeWord,
        ),
      );
  }
}
