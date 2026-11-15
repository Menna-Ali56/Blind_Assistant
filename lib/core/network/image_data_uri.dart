import 'dart:convert';
import 'dart:typed_data';

import '../constants/app_defaults.dart';
import '../errors/failures/api_failure.dart';
import '../errors/mappers/error_code_registry.dart';
import '../errors/result/result.dart';

abstract interface class ImageCompressor {
  Future<Uint8List> compress(Uint8List bytes, {required int quality});
}

class ImageDataUri {
  const ImageDataUri(this._compressor);

  static const String jpegPrefix = 'data:image/jpeg;base64,';

  final ImageCompressor _compressor;

  Future<Result<String>> encode(Uint8List bytes) async {
    for (final quality in AppDefaults.imageQualitySteps) {
      final output = await _compressor.compress(bytes, quality: quality);
      if (output.lengthInBytes <= AppDefaults.maxImageBytes) {
        return ResultSuccess('$jpegPrefix${base64Encode(output)}');
      }
    }
    return ResultFailure(ApiFailure.fromCode(ErrorCodeRegistry.fileTooLarge));
  }
}
