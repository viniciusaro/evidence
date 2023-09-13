import 'dart:developer';

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

extension StreamExtensions<T> on Stream<T> {
  Stream<T> debug({String prefix = "", Function(String) logger = log, dynamic Function(T)? map}) {
    return this.map((event) {
      final eventMap = map ?? (e) => e;
      logger("[${DateTime.now()}]: " + prefix + eventMap(event).toString());
      return event;
    }).handleError((Object e, s) {
      logger("[${DateTime.now()}]: ERROR" + prefix + e.toString());
      throw e;
    });
  }
}
