part of 'data_source.dart';

class HiveKeyJsonDataSource with DataSource<Key, JSON> {
  final Box box;

  HiveKeyJsonDataSource(this.box);

  @override
  Future<Result<JSON, DataSourceGetException>> get(Key query) {
    if (box.containsKey(query)) {
      return Future.value(Result.success(box.getJSON(query)));
    }
    return Future.value(Result.exception(NotFoundException()));
  }

  @override
  Future<Result<Void, Never>> put(JSON value, Key query) async {
    await box.put(query, value);
    return Future.value(Result.success(unit));
  }

  @override
  Stream<Result<JSON, Never>> subscribe(Key query) {
    final controller = StreamController<JSON>();
    final listenable = box.listenable(keys: [query]);

    if (box.containsKey(query)) {
      controller.add(box.getJSON(query));
    }

    final listener = () {
      controller.add(listenable.value.getJSON(query));
    };

    listenable.addListener(listener);

    return controller.stream.doOnCancel(() {
      listenable.removeListener(listener);
      controller.close();
    }).map(Result.success);
  }
}

extension BoxGetJson on Box {
  JSON getJSON(String key, {JSON? defaultValue}) {
    final value = get(key, defaultValue: defaultValue);
    return JSONFactory.fromRecursive(value as Map);
  }
}

// Hive bug
extension JSONFactory on JSON {
  static JSON fromRecursive(Map other) {
    final result = JSON();
    for (final entry in other.entries) {
      final value = entry.value;

      if (value is List<dynamic>) {
        result[entry.key.toString()] = value.map((map) => JSONFactory.fromRecursive(map)).toList();
      } else if (value is Map) {
        result[entry.key.toString()] = JSONFactory.fromRecursive(value);
      } else {
        result[entry.key.toString()] = value;
      }
    }
    return result;
  }
}
