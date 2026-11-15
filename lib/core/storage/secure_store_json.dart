import 'dart:convert';

import 'secure_store.dart';

extension SecureStoreJson on SecureStore {
  Future<Map<String, Object?>?> readJson(String key) async {
    final raw = await read(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, Object?> ? decoded : null;
    } on FormatException {
      return null;
    }
  }

  Future<void> writeJson(String key, Map<String, Object?> value) =>
      write(key, jsonEncode(value));
}
