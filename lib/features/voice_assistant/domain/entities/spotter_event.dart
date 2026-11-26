import 'package:equatable/equatable.dart';

class SpotterEvent extends Equatable {
  const SpotterEvent({required this.keyword, required this.confidence});

  final String keyword;
  final double confidence;

  @override
  List<Object> get props => [keyword, confidence];
}
