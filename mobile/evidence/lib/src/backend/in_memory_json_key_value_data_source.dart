part of 'data_source.dart';

class InMemoryJsonKeyValueDataSource with DataSource<Key, JSON> {
  final Map<Key, JSON> storage = {};

  @override
  Stream<Result<JSON, DataSourceGetException>> get(Key query) {
    final value = storage[query];

    return value != null
        ? Stream.value(Result.success(value)) //
        : Stream.value(Result.exception(NotFoundException()));
  }

  @override
  Stream<Result<Void, Never>> put(JSON value, Key query) {
    storage[query] = value;
    return Stream.value(Result.success(unit));
  }
}
