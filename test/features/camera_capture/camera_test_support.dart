import 'dart:convert';

import 'package:baseer/core/output/output.dart';
import 'package:baseer/features/camera_capture/camera_capture.dart';
import 'package:baseer/features/camera_capture/presentation/texts/camera_texts.dart';
import 'package:flutter/widgets.dart';

import '../permissions/permission_test_support.dart';

const Key previewKey = Key('camera_preview');

const String _pixelPng =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADElEQVR4nGNgYGAAAAAEAAH2'
    'FzhVAAAAAElFTkSuQmCC';

class FakeCameraSession implements CameraSession {
  final CapturedImage image = CapturedImage(
    bytes: base64Decode(_pixelPng),
    capturedAt: DateTime(2026),
  );
  Object? openError;
  Object? captureError;
  int opened = 0;
  int captured = 0;
  int closed = 0;

  @override
  Future<void> open() async {
    opened++;
    final error = openError;
    if (error != null) throw error;
  }

  @override
  Future<CapturedImage> capture() async {
    captured++;
    final error = captureError;
    if (error != null) throw error;
    return image;
  }

  @override
  Future<void> close() async => closed++;

  @override
  Widget buildPreview(BuildContext context) =>
      const SizedBox.expand(key: previewKey);
}

class CameraHarness {
  CameraHarness({FakeCameraSession? session, this.language = 'en'})
    : session = session ?? FakeCameraSession() {
    cubit = CameraCaptureCubit(
      session: this.session,
      output: OutputCoordinator(channel),
      languageCode: () => language,
    );
  }

  final FakeCameraSession session;
  final String language;
  final RecordingChannel channel = RecordingChannel();
  late final CameraCaptureCubit cubit;

  CameraTexts get texts => cubit.texts;
}
