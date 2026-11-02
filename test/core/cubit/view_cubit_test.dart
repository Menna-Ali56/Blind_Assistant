import 'package:flutter_test/flutter_test.dart';

import 'package:baseer/core/cubit/view_cubit.dart';
import 'package:baseer/core/cubit/view_state.dart';
import 'package:baseer/core/cubit/view_status.dart';

class _ProbeCubit extends ViewCubit<int> {}

void main() {
  const value = 7;
  final failure = StateError('failed');

  test('run emits loading then success', () async {
    final cubit = _ProbeCubit();
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        const ViewState<int>(status: ViewStatus.loading),
        const ViewState<int>(status: ViewStatus.success, data: value),
      ]),
    );
    await cubit.run(() async => value);
    await expectation;
    await cubit.close();
  });

  test('run emits loading then failure', () async {
    final cubit = _ProbeCubit();
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        const ViewState<int>(status: ViewStatus.loading),
        ViewState<int>(status: ViewStatus.failure, error: failure),
      ]),
    );
    await cubit.run(() async => throw failure);
    await expectation;
    await cubit.close();
  });

  test('late result after close is ignored', () async {
    final cubit = _ProbeCubit();
    final pending = cubit.run(() async => value);
    await cubit.close();
    await pending;
    expect(cubit.state.status, ViewStatus.loading);
  });
}
