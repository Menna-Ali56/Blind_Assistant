import '../../../../core/constants/app_defaults.dart';


enum TextSizeStep {
  normal(AppDefaults.textScale),
  large(1.3),
  extraLarge(1.6);

  const TextSizeStep(this.scale);

  final double scale;

  TextSizeStep get next => values[(index + 1) % values.length];


  static TextSizeStep fromScale(double scale) {
    var best = normal;
    for (final step in values) {
      if ((step.scale - scale).abs() < (best.scale - scale).abs()) {
        best = step;
      }
    }
    return best;
  }
}
