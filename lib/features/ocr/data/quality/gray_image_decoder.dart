import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../../domain/quality/gray_image.dart';

abstract final class GrayImageDecoder {
  static const String _failureMessage = 'Image bytes cannot be decoded';

  static GrayImage decode(Uint8List bytes, {required int longSide}) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) throw const FormatException(_failureMessage);
    final gray = img.grayscale(_fit(decoded, longSide));
    final luma = Uint8List(gray.width * gray.height);
    var index = 0;
    for (final pixel in gray) {
      luma[index++] = pixel.r.toInt();
    }
    return GrayImage(width: gray.width, height: gray.height, luma: luma);
  }

  static img.Image _fit(img.Image source, int longSide) {
    if (max(source.width, source.height) <= longSide) return source;
    final wide = source.width >= source.height;
    return img.copyResize(
      source,
      width: wide ? longSide : null,
      height: wide ? null : longSide,
      interpolation: img.Interpolation.average,
    );
  }
}
