import 'package:evidence_domain/domain.dart';

mixin TopicRepository {
  Stream<Result<EvidenceTopic, Never>> getTopic(EvidenceTopicId id);
  Stream<Result<EvidenceTopics, Never>> getTopics();
  Future<Result<Void, Never>> likeTopic(EvidenceTopic topic);

  Future<Result<EvidenceTopic, Never>> postTopic(EvidenceTopicPost post);
  Future<Result<Void, Never>> registerTopicPost(EvidenceTopicPost post);
  Future<Result<Void, Never>> unregisterTopicPost(EvidenceTopicPost post);
  Stream<Result<EvidenceTopicPosts, Never>> getTopicPosts();
}
