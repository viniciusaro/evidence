import 'dart:async';

import 'package:evidence_foundation_flutter/foundation.dart';

part 'in_memory_json_key_value_data_source.dart';

typedef JSON = Map<String, dynamic>;
typedef Key = String;

mixin DataSource<Query, RawRepresentation> {
  Future<Result<RawRepresentation, DataSourceGetException>> get(Query query);
  Stream<Result<RawRepresentation, Never>> subscribe(Query query);
  Future<Result<Void, Never>> put(RawRepresentation value, Query query);
}

sealed class DataSourceGetException {}

class NotFoundException extends DataSourceGetException {}

extension DataSourceStream<T> on Stream<Result<T, DataSourceGetException>> {
  Stream<Result<T, Never>> onNotFoundReturn(T fallback) {
    return onResultException((exception) {
      switch (exception) {
        case NotFoundException():
          return fallback;
      }
    });
  }
}

extension DataSourceFuture<T> on Future<Result<T, DataSourceGetException>> {
  Future<Result<T, Never>> onNotFoundReturn(T fallback) {
    return onResultException((exception) {
      switch (exception) {
        case NotFoundException():
          return fallback;
      }
    });
  }
}
