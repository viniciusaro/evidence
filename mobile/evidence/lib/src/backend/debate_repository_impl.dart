import 'package:evidence_domain/domain.dart';
import 'package:evidence_foundation_flutter/foundation.dart';

class DebateRepositoryImpl implements DebateRepository {
  @override
  Stream<Result<Void, Never>> contestTopic(EvidenceTopic topic) {
    // TODO: implement contestTopic
    throw UnimplementedError();
  }

  @override
  Stream<Result<EvidenceArgument, Never>> getArguments(EvidenceTopic topic) {
    // TODO: implement getArguments
    throw UnimplementedError();
  }

  @override
  Stream<Result<EvidenceTopic, Never>> getTopic(EvidenceTopicId id) {
    // TODO: implement getTopic
    throw UnimplementedError();
  }

  @override
  Stream<Result<List<EvidenceTopic>, Never>> getTopics() {
    // TODO: implement getTopics
    throw UnimplementedError();
  }

  @override
  Stream<Result<Void, Never>> likeTopic(EvidenceTopic topic) {
    // TODO: implement likeTopic
    throw UnimplementedError();
  }

  @override
  Stream<Result<Void, Never>> supportTopic(EvidenceTopic topic) {
    // TODO: implement supportTopic
    throw UnimplementedError();
  }
}
