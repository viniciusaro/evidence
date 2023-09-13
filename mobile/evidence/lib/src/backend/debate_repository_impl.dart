import 'package:evidence_domain/domain.dart';
import 'package:evidence_foundation_flutter/foundation.dart';

import 'data_source.dart';

class DebateRepositoryImpl implements DebateRepository {
  final DataSource<Key, JSON> dataSource;

  DebateRepositoryImpl({required this.dataSource});

  @override
  Stream<Result<EvidenceTopic, Never>> getTopic(EvidenceTopicId id) {
    return getTopics() //
        .mapResult((topics) => topics.firstWhere((topic) => topic.id == id));
  }

  @override
  Stream<Result<List<EvidenceTopic>, Never>> getTopics() {
    return dataSource
        .get("EvidenceTopics")
        .mapResult(EvidenceTopics.fromJson)
        .mapResult((topics) => topics.topics)
        .onNotFoundReturn([]);
  }

  @override
  Stream<Result<Void, Never>> registerTopic(EvidenceTopic topic) {
    return dataSource
        .get("EvidenceTopics")
        .take(1)
        .mapResult(EvidenceTopics.fromJson)
        .onNotFoundReturn(EvidenceTopics(topics: []))
        .mapResult((topics) => topics.copyWith(topics: topics.topics + [topic]))
        .switchMapResult((topics) => dataSource.put(topics.toJson(), "EvidenceTopics").take(1));
  }
}
