import 'dart:typed_data';

class GrayImage {
  const GrayImage({
    required this.width,
    required this.height,
    required this.luma,
  });

  final int width;
  final int height;
  final Uint8List luma;

  int at(int x, int y) => luma[y * width + x];
}
