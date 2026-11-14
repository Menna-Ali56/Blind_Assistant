import 'package:get_it/get_it.dart';

import '../../core/accessibility/screen_reader_status.dart';
import '../../core/consent/granted_consent.dart';
import '../../core/di/cubit_registration.dart';
import '../../core/di/di_module.dart';
import '../../core/errors/errors.dart';
import '../../core/output/output.dart';
import '../../core/storage/secure_store.dart';
import 'data/repositories/consent_repository_impl.dart';
import 'domain/repositories/consent_remote.dart';
import 'domain/repositories/consent_repository.dart';
import 'presentation/cubit/consent_cubit.dart';

class ConsentModule implements DiModule {
  const ConsentModule({this.languageCode = defaultLanguageCode});

  final String Function() languageCode;

  @override
  void register(GetIt locator) {
    if (!locator.isRegistered<ConsentRemote>()) {
      locator.registerLazySingleton<ConsentRemote>(NoConsentRemote.new);
    }
    locator
      ..registerLazySingleton<ConsentRepository>(
        () => ConsentRepositoryImpl(
          locator<SecureStore>(),
          errorHandler: locator<ErrorHandler>(),
        ),
      )
      ..registerLazySingleton<GrantedConsent>(GrantedConsent.new)
      ..registerSharedCubit<ConsentCubit>(
        (l) => ConsentCubit(
          repository: l<ConsentRepository>(),
          granted: l<GrantedConsent>(),
          output: l<OutputCoordinator>(),
          languageCode: languageCode,
          remote: l<ConsentRemote>(),
          screenReader: l.isRegistered<ScreenReaderStatus>()
              ? l<ScreenReaderStatus>()
              : const PlatformScreenReaderStatus(),
        ),
      );
  }
}
