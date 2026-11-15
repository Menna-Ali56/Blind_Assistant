import 'package:baseer/core/network/api_client.dart';
import 'package:baseer/core/network/api_config.dart';
import 'package:baseer/core/tasks/task_id_generator.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'stub_adapter.dart';

const String _baseUrl = 'http://localhost';
const String _givenId = 'given-id';

void main() {
  late StubAdapter adapter;
  late Dio dio;

  setUp(() {
    adapter = StubAdapter(status: 200);
    dio = buildApiClient(baseUrl: _baseUrl, ids: UuidV4Generator())
      ..httpClientAdapter = adapter;
  });

  test('uses the id given by the caller', () async {
    await dio.get<dynamic>(
      '/x',
      options: Options(extra: {ApiHeaders.clientTaskIdExtra: _givenId}),
    );

    expect(adapter.lastRequest!.headers[ApiHeaders.clientTaskId], _givenId);
  });

  test('makes an id when the caller gives none', () async {
    await dio.get<dynamic>('/x');

    expect(adapter.lastRequest!.headers[ApiHeaders.clientTaskId], isNotEmpty);
  });

  test('client has the agreed timeouts', () {
    expect(dio.options.connectTimeout, ApiConfig.connectTimeout);
    expect(dio.options.receiveTimeout, ApiConfig.receiveTimeout);
    expect(dio.options.receiveTimeout! > const Duration(seconds: 12), isTrue);
  });
}
