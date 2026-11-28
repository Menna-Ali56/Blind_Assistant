import '../cubit/camera_stage.dart';
import 'camera_texts.dart';

const CameraTexts englishCameraTexts = CameraTexts(
  title: 'Camera',
  previewLabel: 'Camera view',
  reviewLabel: 'Captured photo',
  captureAction: 'Capture photo',
  retakeAction: 'Retake',
  useAction: 'Use photo',
  retryAction: 'Try again',
  messages: {
    CameraStage.opening: 'Opening the camera.',
    CameraStage.ready:
        'The camera is ready. Hold the phone steady and point it at the '
        'text. Then tap the capture photo button.',
    CameraStage.capturing: 'Taking the photo. Stay still.',
    CameraStage.review:
        'The photo is taken. Tap use photo to continue or retake to try '
        'again.',
    CameraStage.accepted: 'Using this photo.',
    CameraStage.openFailed: 'The camera could not start. Tap try again.',
    CameraStage.captureFailed: 'The photo could not be taken. Tap try again.',
  },
);
