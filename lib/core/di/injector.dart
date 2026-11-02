import 'package:get_it/get_it.dart';

import 'di_module.dart';

final GetIt sl = GetIt.instance;

void configureDependencies(Iterable<DiModule> modules, {GetIt? locator}) {
  final target = locator ?? sl;
  for (final module in modules) {
    module.register(target);
  }
}

Future<void> resetDependencies() => sl.reset();
