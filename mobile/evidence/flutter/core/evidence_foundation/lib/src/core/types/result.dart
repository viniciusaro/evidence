part 'result.extensions.dart';

sealed class Result<T, E> {
  const Result._();

  factory Result.success(T value) = ResultSuccess<T, E>;

  /// Represents a predictable outcome of calling a function and, as such,
  /// should be properly handled by the caller.
  ///
  /// Similar to a Flutter [Exception].
  /// https://github.com/dart-lang/sdk/blob/b555e71ecdcca112f449da1656b273663aa65d83/sdk/lib/core/exceptions.dart#L23
  factory Result.exception(E value) = ResultException<T, E>;

  /// Represents a programming issue that cannot be handled in code.
  ///
  /// Similar to a Flutter [Error].
  /// reference: https://github.com/dart-lang/sdk/blob/b555e71ecdcca112f449da1656b273663aa65d83/sdk/lib/core/errors.dart#L72
  factory Result.error(Object value, StackTrace stackTrace) = ResultError<T, E>;
}

class ResultSuccess<T, E> extends Result<T, E> {
  final T value;
  const ResultSuccess(this.value) : super._();

  @override
  int get hashCode => value.hashCode ^ 31;

  @override
  operator ==(Object other) {
    return other is ResultSuccess && value == other.value;
  }
}

class ResultException<T, E> extends Result<T, E> {
  final E exception;
  const ResultException(this.exception) : super._();

  @override
  int get hashCode => exception.hashCode ^ 31;

  @override
  operator ==(Object other) {
    return other is ResultException && exception == other.exception;
  }
}

class ResultError<T, E> extends Result<T, E> {
  final Object error;
  final StackTrace stackTrace;
  const ResultError(this.error, this.stackTrace) : super._();

  @override
  int get hashCode => error.hashCode ^ stackTrace.hashCode ^ 31;

  @override
  operator ==(Object other) {
    return other is ResultError && error == other.error && stackTrace == other.stackTrace;
  }
}
