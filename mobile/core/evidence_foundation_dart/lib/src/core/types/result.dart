sealed class Result<T, E> {
  const Result._();

  factory Result.success(T value) = _ResultSuccess<T, E>;

  /// Represents a predictable outcome of calling a function and, as such,
  /// should be properly handled by the caller.
  ///
  /// Similar to a Flutter [Exception].
  /// https://github.com/dart-lang/sdk/blob/b555e71ecdcca112f449da1656b273663aa65d83/sdk/lib/core/exceptions.dart#L23
  factory Result.exception(E value) = _ResultException<T, E>;

  /// Represents a programming issue that cannot be handled in code.
  ///
  /// Similar to a Flutter [Error].
  /// reference: https://github.com/dart-lang/sdk/blob/b555e71ecdcca112f449da1656b273663aa65d83/sdk/lib/core/errors.dart#L72
  factory Result.error(Object value) = _ResultError<T, E>;
}

class _ResultSuccess<T, E> extends Result<T, E> {
  final T value;
  const _ResultSuccess(this.value) : super._();

  @override
  int get hashCode => value.hashCode ^ 31;

  @override
  operator ==(Object other) {
    return other is _ResultSuccess && value == other.value;
  }
}

class _ResultException<T, E> extends Result<T, E> {
  final E exception;
  const _ResultException(this.exception) : super._();

  @override
  int get hashCode => exception.hashCode ^ 31;

  @override
  operator ==(Object other) {
    return other is _ResultException && exception == other.exception;
  }
}

class _ResultError<T, E> extends Result<T, E> {
  final Object error;
  const _ResultError(this.error) : super._();

  @override
  int get hashCode => error.hashCode ^ 31;

  @override
  operator ==(Object other) {
    return other is _ResultError && error == other.error;
  }
}
