import '../../execution/unavailable_reason.dart';
import 'failure.dart';

class ExecutionFailure extends Failure {
  ExecutionFailure(this.reason)
    : super(
        messageKey: reason.messageKey,
        code: 'execution',
        isRetryable: reason.isRetryable,
      );

  final UnavailableReason reason;

  @override
  List<Object?> get props => [...super.props, reason];
}
