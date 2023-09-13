import 'package:evidence_domain/domain.dart';
import 'package:evidence_foundation_dart/foundation.dart';

mixin DebateRepository {
  Stream<Result<List<EvidenceTopic>, Never>> getTopics();
  Stream<Result<EvidenceTopic, Never>> getTopic(EvidenceTopicId id);
  Stream<Result<EvidenceArgument, Never>> getArguments(EvidenceTopic topic);
  Stream<Result<Void, Never>> likeTopic(EvidenceTopic topic);
  Stream<Result<Void, Never>> supportTopic(EvidenceTopic topic);
  Stream<Result<Void, Never>> contestTopic(EvidenceTopic topic);
}
