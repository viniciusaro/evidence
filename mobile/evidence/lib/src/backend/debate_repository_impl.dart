import 'dart:math';

import 'package:evidence_domain/domain.dart';

import 'data_source.dart';

class DebateRepositoryImpl implements DebateRepository {
  final DataSource<Key, JSON> dataSource;

  const DebateRepositoryImpl({required this.dataSource});

  @override
  Stream<Result<EvidenceTopic, Never>> getTopic(EvidenceTopicId id) {
    return getTopics() //
        .mapResult((topics) => topics.topics.firstWhere((topic) => topic.id == id));
  }

  @override
  Stream<Result<EvidenceTopicPosts, Never>> getTopicPosts() {
    return dataSource
        .subscribe(EvidenceTopicPosts.key)
        .mapResult(EvidenceTopicPosts.fromJson)
        .onNotFoundReturn(EvidenceTopicPosts());
  }

  @override
  Stream<Result<EvidenceTopics, Never>> getTopics() {
    return dataSource
        .subscribe(EvidenceTopics.key)
        .mapResult(EvidenceTopics.fromJson)
        .onNotFoundReturn(EvidenceTopics());
  }

  @override
  Future<Result<Void, Never>> registerTopicPost(EvidenceTopicPost topic) {
    return dataSource
        .get(EvidenceTopicPosts.key)
        .mapResult(EvidenceTopicPosts.fromJson)
        .onNotFoundReturn(EvidenceTopicPosts())
        .mapResult((topics) => topics.copyWith(topics: topics.topics + [topic]))
        .flatMapResult((topics) => dataSource.put(topics.toJson(), EvidenceTopicPosts.key));
  }

  @override
  Future<Result<Void, Never>> unregisterTopicPost(EvidenceTopicPost topic) {
    return dataSource
        .get(EvidenceTopicPosts.key)
        .mapResult(EvidenceTopicPosts.fromJson)
        .onNotFoundReturn(EvidenceTopicPosts())
        .mapResult((topics) => topics.copyWith(topics: topics.topics.removing(topic)))
        .flatMapResult((topics) => dataSource.put(topics.toJson(), EvidenceTopicPosts.key));
  }

  @override
  Future<Result<EvidenceTopic, Never>> postTopic(EvidenceTopicPost post) async {
    await Future.delayed(const Duration(seconds: 2));
    final publisher = EvidenceTopicPublisher(
      id: "1",
      name: "Vini Rodrigues",
      profilePictureUrl: "https://pbs.twimg.com/profile_images/1584303098687885312/SljBjw26_400x400.jpg",
    );

    final topic = EvidenceTopic(
      id: Random().nextInt(100000).toString(),
      declaration: post.declaration,
      publisher: publisher,
      arguments: [],
    );

    return dataSource
        .get(EvidenceTopics.key)
        .mapResult(EvidenceTopics.fromJson)
        .onNotFoundReturn(EvidenceTopics(topics: []))
        .mapResult((topics) => topics.copyWith(topics: topics.topics + [topic]))
        .flatMapResult((topics) => dataSource.put(topics.toJson(), EvidenceTopics.key))
        .flatMapResult((_) => unregisterTopicPost(post))
        .mapResult((_) => topic);
  }
}
