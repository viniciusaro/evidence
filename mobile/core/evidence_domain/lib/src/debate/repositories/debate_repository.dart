import 'package:evidence_domain/domain.dart';

mixin DebateRepository {
  Stream<Result<EvidenceTopic, Never>> getTopic(EvidenceTopicId id);
  Stream<Result<EvidenceTopics, Never>> getTopics();
  Future<Result<Void, Never>> likeTopic(EvidenceTopic topic);

  Future<Result<EvidenceTopic, Never>> postTopic(EvidenceTopicPost post);
  Future<Result<Void, Never>> registerTopicPost(EvidenceTopicPost post);
  Future<Result<Void, Never>> unregisterTopicPost(EvidenceTopicPost post);
  Stream<Result<EvidenceTopicPosts, Never>> getTopicPosts();

  Future<Result<EvidenceArgument, Never>> postArgument(EvidenceArgumentPost post);
  Future<Result<Void, Never>> registerArgumentPost(EvidenceArgumentPost post);
  Future<Result<Void, Never>> unregisterArgumentPost(EvidenceArgumentPost post);
  Stream<Result<EvidenceArgumentPosts, Never>> getArgumentPosts();
}
