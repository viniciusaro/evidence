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
    return dataSource //
        .subscribe(EvidenceTopicPosts.key)
        .mapResult(EvidenceTopicPosts.fromJson);
  }

  @override
  Stream<Result<EvidenceTopics, Never>> getTopics() {
    return dataSource //
        .subscribe(EvidenceTopics.key)
        .mapResult(EvidenceTopics.fromJson);
  }

  @override
  Future<Result<Void, Never>> likeTopic(EvidenceTopic topic) {
    topic = topic.copyWith(likeCount: topic.likeCount + 1);

    return dataSource
        .get(EvidenceTopics.key)
        .mapResult(EvidenceTopics.fromJson)
        .onNotFoundReturn(EvidenceTopics(topics: []))
        .mapResult((topics) => topics.copyWith(topics: topics.topics.map((t) => t.id == topic.id ? topic : t).toList()))
        .flatMapResult((topics) => dataSource.put(topics.toJson(), EvidenceTopics.key));
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
    await Future.delayed(const Duration(seconds: 1));
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
        .onNotFoundReturn(EvidenceTopics())
        .mapResult((topics) => topics.copyWith(topics: topics.topics + [topic]))
        .flatMapResult((topics) => dataSource.put(topics.toJson(), EvidenceTopics.key))
        .flatMapResult((_) => unregisterTopicPost(post))
        .mapResult((_) => topic);
  }

  @override
  Future<Result<EvidenceArgument, Never>> postArgument(EvidenceArgumentPost post) async {
    await Future.delayed(const Duration(seconds: 1));
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

    final argument = EvidenceArgument(
      id: Random().nextInt(100000).toString(),
      topic: topic,
      type: post.type,
    );

    final postArgumentTopic = () => dataSource
        .get(EvidenceTopics.key)
        .mapResult(EvidenceTopics.fromJson)
        .onNotFoundReturn(EvidenceTopics())
        .mapResult((topics) => topics.copyWith(topics: topics.topics + [topic]))
        .flatMapResult((topics) => dataSource.put(topics.toJson(), EvidenceTopics.key));

    final postArgumentToAboutTopic = () => dataSource
        .get(EvidenceTopics.key)
        .mapResult(EvidenceTopics.fromJson)
        .onNotFoundReturn(EvidenceTopics())
        .mapResult((topics) => topics.copyWithNewArgumentForTopic(argument, post.aboutTopic))
        .flatMapResult((topics) => dataSource.put(topics.toJson(), EvidenceTopics.key));

    return dataSource
        .get(EvidenceArguments.key)
        .mapResult(EvidenceArguments.fromJson)
        .onNotFoundReturn(EvidenceArguments())
        .mapResult((arguments) => arguments.copyWith(arguments: arguments.arguments + [argument]))
        .flatMapResult((arguments) => dataSource.put(arguments.toJson(), EvidenceArguments.key))
        .flatMapResult((_) => postArgumentTopic())
        .flatMapResult((_) => postArgumentToAboutTopic())
        .flatMapResult((_) => unregisterArgumentPost(post))
        .mapResult((_) => argument);
  }

  @override
  Future<Result<Void, Never>> registerArgumentPost(EvidenceArgumentPost argument) {
    return dataSource
        .get(EvidenceArgumentPosts.key)
        .mapResult(EvidenceArgumentPosts.fromJson)
        .onNotFoundReturn(EvidenceArgumentPosts())
        .mapResult((arguments) => arguments.copyWith(arguments: arguments.arguments + [argument]))
        .flatMapResult((arguments) => dataSource.put(arguments.toJson(), EvidenceArgumentPosts.key));
  }

  @override
  Future<Result<Void, Never>> unregisterArgumentPost(EvidenceArgumentPost post) {
    return dataSource
        .get(EvidenceArgumentPosts.key)
        .mapResult(EvidenceArgumentPosts.fromJson)
        .onNotFoundReturn(EvidenceArgumentPosts())
        .mapResult((arguments) => arguments.copyWith(arguments: arguments.arguments.removing(post)))
        .flatMapResult((arguments) => dataSource.put(arguments.toJson(), EvidenceArgumentPosts.key));
  }

  @override
  Stream<Result<EvidenceArgumentPosts, Never>> getArgumentPosts() {
    return dataSource //
        .subscribe(EvidenceArgumentPosts.key)
        .mapResult(EvidenceArgumentPosts.fromJson);
  }
}
