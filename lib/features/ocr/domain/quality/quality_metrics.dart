import 'package:equatable/equatable.dart';

class QualityMetrics extends Equatable {
  const QualityMetrics({required this.sharpness, required this.brightness});

  final double sharpness;
  final double brightness;

  @override
  List<Object?> get props => [sharpness, brightness];
}
