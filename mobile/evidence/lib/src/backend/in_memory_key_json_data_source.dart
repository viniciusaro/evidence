part of 'data_source.dart';

class InMemoryKeyJsonDataSource with DataSource<Key, JSON> {
  final Map<Key, JSON> storage = {};
  final Map<Key, StreamController<JSON>> controllers = {};

  InMemoryKeyJsonDataSource();

  @override
  Future<Result<JSON, DataSourceGetException>> get(Key query) {
    final value = storage[query];

    return value != null
        ? Future.value(Result.success(value)) //
        : Future.value(Result.exception(NotFoundException()));
  }

  @override
  Stream<Result<JSON, Never>> subscribe(Key query) {
    final value = storage[query];
    final controller = controllers[query] ??= StreamController();

    return value != null
        ? controller.stream.startWith(value).map((json) => Result.success(json))
        : controller.stream.map((json) => Result.success(json));
  }

  @override
  Future<Result<Void, Never>> put(JSON value, Key query) {
    storage[query] = value;
    final controller = controllers[query] ??= StreamController();
    controller.add(value);
    return Future.value(Result.success(unit));
  }
}
