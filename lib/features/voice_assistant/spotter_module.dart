import 'package:get_it/get_it.dart';

import '../../core/di/di_module.dart';
import '../settings/presentation/cubit/settings_cubit.dart';
import 'data/catalog/command_keywords.dart';
import 'domain/catalog/command_catalog.dart';
import 'domain/catalog/confidence_table.dart';
import 'domain/catalog/spotter_limits.dart';
import 'domain/controller/spotter_controller.dart';
import 'domain/controller/wake_gate.dart';
import 'domain/repositories/command_sink.dart';
import 'domain/repositories/keyword_spotter.dart';

class SpotterModule implements DiModule {
  const SpotterModule();

  @override
  void register(GetIt locator) {
    locator.registerLazySingleton<SpotterController>(
      () => SpotterController(
        spotter: locator<KeywordSpotter>(),
        sink: locator<CommandSink>(),
        catalog: CommandCatalog(CommandKeywords.table),
        thresholds: ConfidenceTable(
          SpotterLimits.thresholds,
          fallback: SpotterLimits.commandConfidence,
        ),
        wakeWordEnabled: () => locator<SettingsCubit>().state.settings.wakeWord,
        gate: WakeGate(now: DateTime.now),
      ),
      dispose: (controller) => controller.dispose(),
    );
  }
}
