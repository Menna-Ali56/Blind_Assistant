import 'base_cubit.dart';
import 'view_state.dart';

abstract class ViewCubit<T> extends BaseCubit<ViewState<T>> {
  ViewCubit() : super(ViewState<T>());

  Future<void> run(Future<T> Function() task) async {
    safeEmit(state.toLoading());
    try {
      safeEmit(state.toSuccess(await task()));
    } catch (error, stackTrace) {
      safeEmit(state.toFailure(error));
      addError(error, stackTrace);
    }
  }
}
