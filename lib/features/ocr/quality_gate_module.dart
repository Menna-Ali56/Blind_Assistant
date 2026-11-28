import 'package:get_it/get_it.dart';

import '../../core/di/cubit_registration.dart';
import '../../core/di/di_module.dart';
import '../../core/output/output.dart';
import '../../core/tasks/task_controller.dart';
import 'data/quality/isolate_quality_measurer.dart';
import 'domain/quality/quality_gate.dart';
import 'domain/quality/quality_measurer.dart';
import 'domain/quality/quality_thresholds.dart';
import 'presentation/advice/quality_announcer.dart';
import 'presentation/cubit/quality_gate_cubit.dart';

class QualityGateModule implements DiModule {
  const QualityGateModule({
    this.languageCode = defaultLanguageCode,
    this.thresholds = QualityThresholds.seed,
  });

  final String Function() languageCode;
  final QualityThresholds thresholds;

  @override
  void register(GetIt locator) {
    if (!locator.isRegistered<QualityMeasurer>()) {
      locator.registerLazySingleton<QualityMeasurer>(
        IsolateQualityMeasurer.new,
      );
    }
    locator
      ..registerLazySingleton<QualityGate>(
        () => QualityGate(locator<QualityMeasurer>(), thresholds: thresholds),
      )
      ..registerCubit<QualityGateCubit>(
        (l) => QualityGateCubit(
          gate: l<QualityGate>(),
          tasks: l<TaskController>(),
          announcer: QualityAnnouncer(
            output: l<OutputCoordinator>(),
            languageCode: languageCode,
          ),
        ),
      );
  }
}
