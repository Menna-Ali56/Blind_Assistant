import 'package:get_it/get_it.dart';

import '../../../core/di/di_module.dart';
import '../../permissions/domain/repositories/permission_repository.dart';
import '../domain/repositories/keyword_spotter.dart';
import 'audio_frame_source.dart';
import 'model_file_source.dart';
import 'record_audio_frame_source.dart';
import 'sherpa_keyword_engine.dart';
import 'sherpa_keyword_spotter.dart';
import 'spotter_model_config.dart';
import 'spotter_model_loader.dart';

class SherpaModule implements DiModule {
  const SherpaModule({this.config = SpotterModelConfig.placeholder});

  final SpotterModelConfig config;

  @override
  void register(GetIt locator) {
    locator
      ..registerLazySingleton<AudioFrameSource>(
        RecordAudioFrameSource.new,
        dispose: (source) => source.dispose(),
      )
      ..registerLazySingleton<KeywordSpotter>(
        () => SherpaKeywordSpotter(
          loader: SpotterModelLoader(config, const IoModelFileSource()),
          source: locator<AudioFrameSource>(),
          permissions: locator<PermissionRepository>(),
          engineFactory: SherpaKeywordEngine.create,
        ),
        dispose: (spotter) => (spotter as SherpaKeywordSpotter).dispose(),
      );
  }
}
