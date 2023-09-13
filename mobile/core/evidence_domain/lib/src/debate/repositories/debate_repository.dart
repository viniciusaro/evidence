import 'package:evidence_domain/domain.dart';
import 'package:evidence_foundation_dart/foundation.dart';

mixin DebateRepository {
  Stream<Result<EvidenceTopic, Never>> getTopic(EvidenceTopicId id);
  Stream<Result<List<EvidenceTopic>, Never>> getTopics();
  Stream<Result<Void, Never>> registerTopic(EvidenceTopic topic);
}
