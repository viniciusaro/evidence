import 'package:evidence_domain/domain.dart';
import 'package:evidence_foundation_flutter/foundation.dart';

import 'data_source.dart';

class DebateRepositoryImpl implements DebateRepository {
  final DataSource<Key, JSON> dataSource;

  DebateRepositoryImpl({required this.dataSource});

  @override
  Stream<Result<Void, Never>> contestTopic(EvidenceTopic topic, EvidenceArgument argument) {
    throw UnimplementedError();
  }

  @override
  Stream<Result<EvidenceArgument, Never>> getArguments(EvidenceTopic topic) {
    throw UnimplementedError();
  }

  @override
  Stream<Result<EvidenceTopic, Never>> getTopic(EvidenceTopicId id) {
    throw UnimplementedError();
  }

  @override
  Stream<Result<List<EvidenceTopic>, Never>> getTopics() {
    throw UnimplementedError();
  }

  @override
  Stream<Result<Void, Never>> likeTopic(EvidenceTopic topic) {
    throw UnimplementedError();
  }

  @override
  Stream<Result<Void, Never>> supportTopic(EvidenceTopic topic) {
    throw UnimplementedError();
  }
}
