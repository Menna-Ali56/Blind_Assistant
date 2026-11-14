import 'app_exception.dart';

class ContractException extends AppException {
  const ContractException({
    super.message = 'Response does not match the contract',
    super.code = 'contract',
    super.cause,
  });
}
