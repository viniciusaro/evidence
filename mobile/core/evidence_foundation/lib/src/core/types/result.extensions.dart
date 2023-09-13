part of 'result.dart';

extension AlwaysSuccessResult<T> on Result<T, Never> {
  T get() {
    switch (this) {
      case ResultSuccess<T, Never> result:
        return result.value;
      case ResultException<T, Never> _:
        throw Never;
      case ResultError<T, Never> _:
        throw Never;
    }
  }
}

extension LiftResult<T, E> on Result<T, E> {
  Result<U, E> map<U>(U Function(T) transform) {
    switch (this) {
      case ResultSuccess<T, E> result:
        return Result.success(transform(result.value));
      case ResultException<T, E> result:
        return Result.exception(result.exception);
      case ResultError<T, E> result:
        return Result.error(result.error, result.stackTrace);
    }
  }

  Result<U, E> flatMap<U>(Result<U, E> Function(T) transform) {
    switch (this) {
      case ResultSuccess<T, E> result:
        return transform(result.value);
      case ResultException<T, E> result:
        return Result.exception(result.exception);
      case ResultError<T, E> result:
        return Result.error(result.error, result.stackTrace);
    }
  }
}
