import 'dart:async';

import 'package:evidence_foundation/foundation.dart';

extension FutureExtension<T> on Future<T> {
  Future<U> map<U>(U Function(T) transform) {
    return then(transform);
  }

  Future<U> flatMap<U>(Future<U> Function(T) transform) {
    return then(transform);
  }
}

extension ResultFuture<T, E> on Future<Result<T, E>> {
  Future<Result<U, E>> mapResult<U>(U Function(T) transform) {
    return map((e) => e.map(transform));
  }

  Future<Result<U, E>> flatMapResult<U>(Future<Result<U, E>> Function(T) transform) {
    return flatMap((result) {
      switch (result) {
        case ResultSuccess<T, E> result:
          return transform(result.value);
        case ResultException<T, E> result:
          return Future.value(Result.exception(result.exception));
        case ResultError<T, E> result:
          return Future.value(Result.error(result.error, result.stackTrace));
      }
    });
  }

  Future<Result<T, Never>> onResultException<U>(T Function(E) transform) {
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
