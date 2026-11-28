import 'package:baseer/core/di/injector.dart';
import 'package:baseer/core/output/output.dart';
import 'package:baseer/core/tasks/tasks.dart';
import 'package:baseer/features/ocr/domain/quality/quality_gate.dart';
import 'package:baseer/features/ocr/domain/quality/quality_thresholds.dart';
import 'package:baseer/features/ocr/presentation/cubit/quality_gate_cubit.dart';
import 'package:baseer/features/ocr/quality_gate_module.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  test('the quality cubit resolves with the seed thresholds', () async {
    final locator = GetIt.asNewInstance()..allowReassignment = true;
    configureDependencies(const [
      OutputModule(),
      TasksModule(),
      QualityGateModule(),
    ], locator: locator);
    locator.registerLazySingleton<AudioFocus>(NoAudioFocus.new);

    expect(locator<QualityGateCubit>(), isA<QualityGateCubit>());
    expect(locator<QualityGate>().thresholds, QualityThresholds.seed);

    await locator.reset();
  });
}
