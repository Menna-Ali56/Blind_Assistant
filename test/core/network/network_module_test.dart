import 'package:baseer/core/di/injector.dart';
import 'package:baseer/core/network/api_error_interceptor.dart';
import 'package:baseer/core/network/attempt_tracker.dart';
import 'package:baseer/core/network/network_module.dart';
import 'package:baseer/core/network/request_ids_interceptor.dart';
import 'package:baseer/core/tasks/tasks_module.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  late GetIt locator;

  setUp(() {
    locator = GetIt.asNewInstance();
    configureDependencies(const [
      NetworkModule(),
      TasksModule(),
    ], locator: locator);
  });

  test('registers dio singleton with expected interceptors', () {
    final dio = locator<Dio>();

    expect(dio, same(locator<Dio>()));
    expect(dio.interceptors.any((i) => i is RequestIdsInterceptor), isTrue);
    expect(dio.interceptors.any((i) => i is ApiErrorInterceptor), isTrue);
  });

  test('registers a fresh attempt tracker per resolution', () {
    expect(locator<AttemptTracker>(), isNot(same(locator<AttemptTracker>())));
  });
}
