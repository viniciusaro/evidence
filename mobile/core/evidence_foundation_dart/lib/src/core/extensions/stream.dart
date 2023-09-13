import 'package:evidence_foundation_dart/foundation.dart';

extension ResultStream<T, E> on Stream<Result<T, E>> {
  Stream<Result<U, E>> mapResult<U>(U Function(T) transform) {
    return map((e) => e.map(transform));
  }

  Stream<Result<U, E>> asyncExpandResult<U>(Stream<Result<U, E>> Function(T) transform) {
    return asyncExpand((result) {
      switch (result) {
        case ResultSuccess<T, E> result:
          return transform(result.value);
        case ResultException<T, E> result:
          return Stream.value(Result.exception(result.exception));
        case ResultError<T, E> result:
          return Stream.value(Result.error(result.error, result.stackTrace));
      }
    });
  }

  // Stream<Result<T, E>> whereResult<U>(bool Function(T) condition) {
  //   return where((result) {
  //     switch (result) {
  //       case ResultSuccess<T, E> result:
  //         return condition(result.value);
  //       case ResultException<T, E> _:
  //         return false;
  //       case ResultError<T, E> _:
  //         return false;
  //     }
  //   });
  // }

  // Stream<Result<T, E>> firstWhereResult<U>(bool Function(T) condition) {
  //   return firstWhere((result) {
  //     switch (result) {
  //       case ResultSuccess<T, E> result:
  //         return condition(result.value);
  //       case ResultException<T, E> _:
  //         return false;
  //       case ResultError<T, E> _:
  //         return false;
  //     }
  //   }).asStream();
  // }

  Stream<Result<T, Never>> onResultException<U>(T Function(E) transform) {
    return map((result) {
      switch (result) {
        case ResultSuccess<T, E> result:
          return Result.success(result.value);
        case ResultException<T, E> result:
          return Result.success(transform(result.exception));
        case ResultError<T, E> result:
          return Result.error(result.error, result.stackTrace);
      }
    });
  }
}
