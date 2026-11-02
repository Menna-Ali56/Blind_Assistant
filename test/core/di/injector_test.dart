import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:baseer/core/di/cubit_registration.dart';
import 'package:baseer/core/di/di_module.dart';
import 'package:baseer/core/di/injector.dart';

class _CounterCubit extends Cubit<int> {
  _CounterCubit() : super(0);
}

class _CounterModule implements DiModule {
  const _CounterModule({required this.shared});

  final bool shared;

  @override
  void register(GetIt locator) {
    if (shared) {
      locator.registerSharedCubit<_CounterCubit>((_) => _CounterCubit());
    } else {
      locator.registerCubit<_CounterCubit>((_) => _CounterCubit());
    }
  }
}

void main() {
  late GetIt locator;

  setUp(() => locator = GetIt.asNewInstance());

  test('factory registration gives a new cubit each time', () {
    configureDependencies([
      const _CounterModule(shared: false),
    ], locator: locator);
    expect(locator<_CounterCubit>(), isNot(same(locator<_CounterCubit>())));
  });

  test('shared registration gives the same cubit', () {
    configureDependencies([
      const _CounterModule(shared: true),
    ], locator: locator);
    expect(locator<_CounterCubit>(), same(locator<_CounterCubit>()));
  });
}
