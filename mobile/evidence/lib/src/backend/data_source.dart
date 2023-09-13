import 'package:evidence_foundation_flutter/foundation.dart';

part 'in_memory_json_key_value_data_source.dart';

typedef JSON = Map<String, dynamic>;
typedef Key = String;

mixin DataSource<Query, T> {
  Stream<Result<T, DataSourceGetException>> get(Query query);
  Stream<Result<Void, Never>> put(T value, Query query);
}

sealed class DataSourceGetException {}

class NotFoundException extends DataSourceGetException {}
