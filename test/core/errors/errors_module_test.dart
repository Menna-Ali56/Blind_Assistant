import 'package:baseer/core/errors/errors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  test('registers the error handler and the supervisor', () {
    final locator = GetIt.asNewInstance();

    const ErrorsModule().register(locator);

    expect(locator<ErrorHandler>(), isA<ErrorHandler>());
    expect(locator<ErrorSupervisor>(), isA<ErrorSupervisor>());
  });
}
