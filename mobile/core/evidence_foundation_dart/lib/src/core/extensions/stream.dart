import 'package:evidence_foundation_dart/foundation.dart';

extension ResultStream<T, E> on Stream<Result<T, E>> {
  Stream<Result<U, E>> mapResult<U>(U Function(T) transform) {
    return map((e) => e.map(transform));
  }

  Stream<Result<U, E>> switchMapResult<U>(Stream<Result<U, E>> Function(T) transform) {
    return switchMap((result) {
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
