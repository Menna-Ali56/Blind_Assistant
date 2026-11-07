import 'package:baseer/core/tasks/tasks.dart';
import 'package:flutter_test/flutter_test.dart';

const int _sampleSize = 200;

final RegExp _uuidV4 = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

void main() {
  final generator = UuidV4Generator();

  test('ids follow the version 4 format', () {
    for (var i = 0; i < _sampleSize; i++) {
      expect(generator.next(), matches(_uuidV4));
    }
  });

  test('ids do not repeat', () {
    final ids = {for (var i = 0; i < _sampleSize; i++) generator.next()};
    expect(ids, hasLength(_sampleSize));
  });
}
