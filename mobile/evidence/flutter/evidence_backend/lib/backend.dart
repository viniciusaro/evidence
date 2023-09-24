import 'package:evidence_backend/src/data_sources/data_source.dart';
import 'package:evidence_backend/src/repositories.dart';
import 'package:evidence_domain/domain.dart';
import 'package:hive_flutter/hive_flutter.dart';

export 'package:hive_flutter/hive_flutter.dart';
export 'src/data_sources.dart';

Repositories repositories(Box box) {
  final dataSource = HiveKeyJsonDataSource(box);
  final topicRepository = TopicRepositoryImpl(dataSource: dataSource);
  final argumentRepository = ArgumentRepositoryImpl(
    dataSource: dataSource,
    topicRepository: topicRepository,
  );

  return Repositories(
    argumentRepository: argumentRepository,
    topicRepository: topicRepository,
  );
}

class Repositories {
  final ArgumentRepository argumentRepository;
  final TopicRepository topicRepository;

  Repositories({
    required this.argumentRepository,
    required this.topicRepository,
  });
}
