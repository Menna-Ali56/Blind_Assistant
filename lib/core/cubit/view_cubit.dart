import 'base_cubit.dart';
import 'view_state.dart';

abstract class ViewCubit<T> extends BaseCubit<ViewState<T>> {
  ViewCubit() : super(ViewState<T>());

  int _runId = 0;

  Future<void> run(Future<T> Function() task) async {
    final id = ++_runId;
    safeEmit(state.toLoading());
    try {
      final result = await task();
      if (id != _runId) return; // فيه طلب أحدث
      safeEmit(state.toSuccess(result));
    } catch (error, stackTrace) {
      if (id != _runId) return;
      safeEmit(state.toFailure(error));
      addError(error, stackTrace);
    }
  }
}
