import 'package:baseer/core/errors/failures/failure.dart';
import 'package:baseer/core/errors/result/result.dart';

const int taskTestValue = 7;
const String taskTestKey = 'scan';
const String taskTestOtherKey = 'read';
const Duration taskTestTimeout = Duration(milliseconds: 10);

Failure? failureOf<T>(Result<T> outcome) => outcome.fold<Failure?>(
  onSuccess: (_) => null,
  onFailure: (failure) => failure,
);

T? dataOf<T>(Result<T> outcome) =>
    outcome.fold<T?>(onSuccess: (data) => data, onFailure: (_) => null);
