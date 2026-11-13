/// Small key value store whose contents are encrypted at rest.
/// Meant for settings, consent and tokens, not for large files.
abstract interface class SecureStore {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);

  Future<void> deleteAll();
}
