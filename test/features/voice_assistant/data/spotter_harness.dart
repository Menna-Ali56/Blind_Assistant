import 'package:baseer/features/permissions/domain/entities/access_status.dart';
import 'package:baseer/features/permissions/domain/entities/permission_kind.dart';
import 'package:baseer/features/voice_assistant/data/keyword_engine.dart';
import 'package:baseer/features/voice_assistant/data/sherpa_keyword_spotter.dart';
import 'package:baseer/features/voice_assistant/data/spotter_model_config.dart';
import 'package:baseer/features/voice_assistant/data/spotter_model_loader.dart';

import '../../permissions/permission_test_support.dart';
import 'spotter_test_support.dart';

class SpotterHarness {
  SpotterHarness({KeywordEngineFactory? engineFactory}) {
    final config = SpotterModelConfig(
      directory: 'dir',
      files: {
        for (final role in SpotterFileRole.values)
          role: SpotterModelFile(
            name: '${role.name}.bin',
            sha256: hashOf(blob),
          ),
      },
    );
    permissions = FakePermissionRepository(
      current: {
        for (final kind in PermissionKind.values) kind: AccessStatus.granted,
      },
    );
    spotter = SherpaKeywordSpotter(
      loader: SpotterModelLoader(
        config,
        FakeModelFileSource({
          for (final file in config.files.values) config.pathOf(file): blob,
        }),
      ),
      source: source,
      permissions: permissions,
      engineFactory: engineFactory ?? (_) => engine,
      onError: errors.add,
    );
  }

  static const blob = [7];

  final FakeAudioFrameSource source = FakeAudioFrameSource();
  final FakeKeywordEngine engine = FakeKeywordEngine();
  final List<Object> errors = [];
  late final FakePermissionRepository permissions;
  late final SherpaKeywordSpotter spotter;
}

Future<void> settle() => Future<void>.delayed(Duration.zero);
