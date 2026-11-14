abstract interface class SessionProvider {
  Future<String?> accessToken();

  Stream<void> get newSessions;
}

class NoSession implements SessionProvider {
  const NoSession();

  @override
  Future<String?> accessToken() async => null;

  @override
  Stream<void> get newSessions => const Stream<void>.empty();
}
