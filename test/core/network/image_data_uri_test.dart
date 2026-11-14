import 'dart:typed_data';

import 'package:baseer/core/constants/app_defaults.dart';
import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/core/network/image_data_uri.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCompressor implements ImageCompressor {
  _FakeCompressor(this.sizeFor);

  final int Function(int quality) sizeFor;

  @override
  Future<Uint8List> compress(Uint8List bytes, {required int quality}) async =>
      Uint8List(sizeFor(quality));
}

void main() {
  final input = Uint8List(1);

  test('returns a jpeg data uri when the image fits', () async {
    final result = await ImageDataUri(_FakeCompressor((_) => 3)).encode(input);

    result.fold(
      onSuccess: (uri) => expect(uri, startsWith(ImageDataUri.jpegPrefix)),
      onFailure: (failure) => fail('should succeed'),
    );
  });

  test('lowers quality until the image fits', () async {
    final steps = AppDefaults.imageQualitySteps;
    final compressor = _FakeCompressor(
      (quality) => quality == steps.last ? 1 : AppDefaults.maxImageBytes + 1,
    );

    expect((await ImageDataUri(compressor).encode(input)).isSuccess, isTrue);
  });

  test('fails with file too large when nothing fits', () async {
    final compressor = _FakeCompressor((_) => AppDefaults.maxImageBytes + 1);
    final result = await ImageDataUri(compressor).encode(input);

    result.fold(
      onSuccess: (_) => fail('should fail'),
      onFailure: (failure) =>
          expect(failure.code, ErrorCodeRegistry.fileTooLarge),
    );
  });
}
