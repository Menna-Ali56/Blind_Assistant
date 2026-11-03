import 'app_exception.dart';

class StorageException extends AppException {
  const StorageException({
    super.message = 'Storage operation failed',
    super.code = 'storage',
    super.cause,
  });
}
