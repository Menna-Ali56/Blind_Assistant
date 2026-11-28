import '../../../../core/cubit/base_cubit.dart';
import '../../../../core/output/output.dart';
import '../../../camera/domain/entities/captured_image.dart';
import '../../domain/repositories/camera_session.dart';
import '../texts/camera_texts.dart';
import '../texts/camera_texts_lookup.dart';
import 'camera_capture_state.dart';
import 'camera_stage.dart';

class CameraCaptureCubit extends BaseCubit<CameraCaptureState> {
  CameraCaptureCubit({
    required this.session,
    required this.output,
    required this.languageCode,
  }) : super(const CameraCaptureState());

  static const String ownerId = 'camera_capture';

  final CameraSession session;
  final OutputCoordinator output;
  final String Function() languageCode;

  CameraTexts get texts => cameraTextsFor(languageCode());

  Future<void> open() async {
    _enter(CameraStage.opening);
    try {
      await session.open();
      _enter(CameraStage.ready);
    } catch (error, stackTrace) {
      _fail(CameraStage.openFailed, error, stackTrace);
    }
  }

  Future<void> capture() async {
    if (state.stage != CameraStage.ready) return;
    _enter(CameraStage.capturing);
    try {
      final image = await session.capture();
      _enter(CameraStage.review, image: image);
    } catch (error, stackTrace) {
      _fail(CameraStage.captureFailed, error, stackTrace);
    }
  }

  void retake() {
    if (state.stage == CameraStage.review) _enter(CameraStage.ready);
  }

  void use() {
    if (state.stage == CameraStage.review) {
      _enter(CameraStage.accepted, image: state.image);
    }
  }

  Future<void> retry() async {
    if (state.stage == CameraStage.captureFailed) {
      _enter(CameraStage.ready);
    } else if (state.stage == CameraStage.openFailed) {
      await open();
    }
  }

  @override
  Future<void> close() async {
    if (state.stage != CameraStage.accepted) output.cancelOwner(ownerId);
    await super.close();
    try {
      await session.close();
    } catch (_) {}
  }

  void _fail(CameraStage stage, Object error, StackTrace stackTrace) {
    _enter(stage);
    if (!isClosed) addError(error, stackTrace);
  }

  void _enter(CameraStage stage, {CapturedImage? image}) {
    if (isClosed) return;
    emit(CameraCaptureState(stage: stage, image: image));
    output.submit(
      OutputMessage(
        text: texts.spoken(stage),
        languageCode: languageCode(),
        priority: stage.isFailure ? OutputPriority.high : OutputPriority.normal,
        haptic: _hapticOf(stage),
        key: ownerId,
        ownerId: ownerId,
      ),
    );
  }

  OutputHaptic _hapticOf(CameraStage stage) => switch (stage) {
    CameraStage.review => OutputHaptic.light,
    CameraStage.openFailed || CameraStage.captureFailed => OutputHaptic.heavy,
    _ => OutputHaptic.none,
  };
}
