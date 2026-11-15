import 'package:baseer/core/storage/storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemorySecureStore store;

  setUp(() => store = InMemorySecureStore());

  test('writes, reads and deletes a value', () async {
    await store.write('a', '1');
    expect(await store.read('a'), '1');

    await store.delete('a');
    expect(await store.read('a'), isNull);
  });

  test('deleteAll removes every value', () async {
    await store.write('a', '1');
    await store.write('b', '2');

    await store.deleteAll();

    expect(await store.read('a'), isNull);
    expect(await store.read('b'), isNull);
  });

  test('json round trip', () async {
    await store.writeJson('k', {'x': 1, 'y': 'text'});

    expect(await store.readJson('k'), {'x': 1, 'y': 'text'});
  });

  test('readJson is null when nothing is stored', () async {
    expect(await store.readJson('missing'), isNull);
  });

  test('readJson is null for damaged or non object json', () async {
    await store.write('broken', '{not json');
    await store.write('list', '[1, 2]');

    expect(await store.readJson('broken'), isNull);
    expect(await store.readJson('list'), isNull);
  });
}
