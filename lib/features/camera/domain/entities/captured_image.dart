import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class CapturedImage extends Equatable {
  const CapturedImage({required this.bytes, required this.capturedAt});

  final Uint8List bytes;
  final DateTime capturedAt;

  int get sizeBytes => bytes.lengthInBytes;

  @override
  List<Object?> get props => [bytes, capturedAt];
}
