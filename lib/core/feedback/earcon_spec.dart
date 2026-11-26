import 'package:equatable/equatable.dart';

class EarconSpec extends Equatable {
  const EarconSpec({
    required this.frequencyHz,
    required this.tone,
    required this.gap,
    required this.volume,
    required this.repeat,
  });

  final int frequencyHz;
  final Duration tone;
  final Duration gap;
  final double volume;
  final int repeat;

  Duration get total => tone * repeat + gap * (repeat - 1);

  @override
  List<Object> get props => [frequencyHz, tone, gap, volume, repeat];
}
