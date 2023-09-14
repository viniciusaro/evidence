import 'package:evidence_domain/domain.dart';

mixin DebateRepository {
  Stream<Result<EvidenceTopic, Never>> getTopic(EvidenceTopicId id);
  Stream<Result<EvidenceTopics, Never>> getTopics();
  Future<Result<Void, Never>> likeTopic(EvidenceTopic topic);

  Stream<Result<EvidenceTopicPosts, Never>> getTopicPosts();
  Future<Result<Void, Never>> registerTopicPost(EvidenceTopicPost topic);
  Future<Result<Void, Never>> unregisterTopicPost(EvidenceTopicPost topic);
  Future<Result<EvidenceTopic, Never>> postTopic(EvidenceTopicPost topic);
}
