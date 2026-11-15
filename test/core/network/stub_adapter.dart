import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

class StubAdapter implements HttpClientAdapter {
  StubAdapter({required this.status, this.body = const {}});

  final int status;
  final Map<String, dynamic> body;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
