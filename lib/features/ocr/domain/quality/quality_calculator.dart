import 'gray_image.dart';
import 'quality_metrics.dart';

abstract final class QualityCalculator {
  static const int _kernelCenter = 4;
  static const int _kernelSpan = 3;

  static QualityMetrics measure(GrayImage image) => QualityMetrics(
    sharpness: _sharpness(image),
    brightness: _brightness(image),
  );

  static double _brightness(GrayImage image) {
    if (image.luma.isEmpty) return 0;
    var sum = 0;
    for (final value in image.luma) {
      sum += value;
    }
    return sum / image.luma.length;
  }

  // variance of the laplacian where a low value means few edges
  static double _sharpness(GrayImage image) {
    if (image.width < _kernelSpan || image.height < _kernelSpan) return 0;
    var sum = 0.0;
    var squares = 0.0;
    var count = 0;
    for (var y = 1; y < image.height - 1; y++) {
      for (var x = 1; x < image.width - 1; x++) {
        final response = _response(image, x, y);
        sum += response;
        squares += response * response;
        count++;
      }
    }
    final mean = sum / count;
    return squares / count - mean * mean;
  }

  static int _response(GrayImage image, int x, int y) =>
      _kernelCenter * image.at(x, y) -
      image.at(x - 1, y) -
      image.at(x + 1, y) -
      image.at(x, y - 1) -
      image.at(x, y + 1);
}
