import 'dart:io';

abstract interface class ModelFileSource {
  Future<bool> exists(String path);

  Stream<List<int>> openRead(String path);
}

class IoModelFileSource implements ModelFileSource {
  const IoModelFileSource();

  @override
  Future<bool> exists(String path) => File(path).exists();

  @override
  Stream<List<int>> openRead(String path) => File(path).openRead();
}
