import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

extension CubitRegistration on GetIt {
  void registerCubit<C extends BlocBase<Object?>>(
    C Function(GetIt locator) create,
  ) {
    registerFactory<C>(() => create(this));
  }

  void registerSharedCubit<C extends BlocBase<Object?>>(
    C Function(GetIt locator) create,
  ) {
    registerLazySingleton<C>(
      () => create(this),
      dispose: (cubit) => cubit.close(),
    );
  }
}
