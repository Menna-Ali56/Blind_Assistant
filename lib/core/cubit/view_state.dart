import 'package:equatable/equatable.dart';

import 'view_status.dart';

class ViewState<T> extends Equatable {
  const ViewState({this.status = ViewStatus.initial, this.data, this.error});

  final ViewStatus status;
  final T? data;
  final Object? error;

  bool get isLoading => status == ViewStatus.loading;
  bool get isFailure => status == ViewStatus.failure;
  bool get hasData => data != null;

  ViewState<T> toLoading() =>
      ViewState<T>(status: ViewStatus.loading, data: data);

  ViewState<T> toSuccess(T value) =>
      ViewState<T>(status: ViewStatus.success, data: value);

  ViewState<T> toFailure(Object cause) =>
      ViewState<T>(status: ViewStatus.failure, data: data, error: cause);

  @override
  List<Object?> get props => [status, data, error];
}
