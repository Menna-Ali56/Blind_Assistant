import 'package:baseer/core/di/injector.dart';
import 'package:baseer/core/tasks/tasks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  late GetIt locator;

  setUp(() {
    locator = GetIt.asNewInstance();
    configureDependencies(const [TasksModule()], locator: locator);
  });

  test('one shared controller is registered', () {
    expect(locator<TaskController>(), same(locator<TaskController>()));
  });

  test('the id generator is registered', () {
    expect(locator<TaskIdGenerator>(), isA<UuidV4Generator>());
  });
}
