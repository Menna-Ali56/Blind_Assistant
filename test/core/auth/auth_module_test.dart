import 'package:baseer/core/auth/auth.dart';
import 'package:baseer/core/di/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  test('AuthModule resolves NoSession returning null accessToken', () async {
    final locator = GetIt.asNewInstance();
    configureDependencies([const AuthModule()], locator: locator);

    final session = locator<SessionProvider>();
    expect(session, isA<NoSession>());
    expect(await session.accessToken(), isNull);
    expect(await session.newSessions.isEmpty, isTrue);
  });
}
