import 'dart:async';
import 'dart:typed_data';

import 'package:baseer/core/output/output.dart';
import 'package:baseer/core/tasks/task_controller.dart';
import 'package:baseer/features/camera/domain/entities/captured_image.dart';
import 'package:baseer/features/ocr/domain/quality/quality_gate.dart';
import 'package:baseer/features/ocr/domain/quality/quality_metrics.dart';
import 'package:baseer/features/ocr/presentation/advice/quality_announcer.dart';
import 'package:baseer/features/ocr/presentation/cubit/quality_flow_state.dart';
import 'package:baseer/features/ocr/presentation/cubit/quality_gate_cubit.dart';
import 'package:baseer/features/ocr/presentation/texts/quality_texts_lookup.dart';
import 'package:baseer/features/ocr/presentation/widgets/quality_retake_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../core/output/output_test_support.dart';
import 'quality_measurers.dart';

const QualityMetrics _blurred = QualityMetrics(sharpness: 1, brightness: 120);

Future<QualityGateCubit> _pump(WidgetTester tester, String language) async {
  final cubit = QualityGateCubit(
    gate: QualityGate(
      ScriptedMeasurer([Completer<QualityMetrics>()..complete(_blurred)]),
    ),
    tasks: TaskController(),
    announcer: QualityAnnouncer(
      output: OutputCoordinator(RecordingOutputChannel()),
      languageCode: () => language,
    ),
  );
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider.value(
        value: cubit,
        child: Scaffold(
          body: Builder(
            builder: (context) => Localizations.override(
              context: context,
              locale: Locale(language),
              child: const QualityRetakeButton(),
            ),
          ),
        ),
      ),
    ),
  );
  return cubit;
}

void main() {
  for (final language in ['en', 'ar']) {
    final label = qualityTextsFor(language).retakeLabel;

    testWidgets('$language button shows only after a rejection', (
      tester,
    ) async {
      final cubit = await _pump(tester, language);
      expect(find.text(label), findsNothing);

      final photo = CapturedImage(
        bytes: Uint8List(1),
        capturedAt: DateTime(2026),
      );
      await tester.runAsync(() => cubit.check(photo));
      await tester.pump();
      expect(find.text(label), findsOneWidget);

      await tester.tap(find.text(label));
      await tester.pump();
      expect(cubit.state.status, QualityFlowStatus.idle);
      expect(find.text(label), findsNothing);
    });
  }
}
