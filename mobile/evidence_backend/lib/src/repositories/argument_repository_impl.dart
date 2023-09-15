import 'dart:math';

import 'package:evidence_backend/src/data_sources.dart';
import 'package:evidence_domain/domain.dart';

class ArgumentRepositoryImpl implements ArgumentRepository {
  final DataSource<Key, JSON> dataSource;
  final TopicRepository topicRepository;

  const ArgumentRepositoryImpl({
    required this.dataSource,
    required this.topicRepository,
  });

  @override
  Future<Result<EvidenceArgument, Never>> postArgument(EvidenceArgumentPost post) async {
    await Future.delayed(const Duration(seconds: 1));
    final publisher = EvidenceTopicPublisher(
      id: "1",
      name: "Vini Rodrigues",
      profilePictureUrl: "https://pbs.twimg.com/profile_images/1584303098687885312/SljBjw26_400x400.jpg",
    );

    final topic = post.relatedTopic ??
        EvidenceTopic(
          id: post.relatedTopicId!,
          declaration: post.declaration,
          publisher: publisher,
          arguments: [],
        );

    final argument = EvidenceArgument(
      id: Random().nextInt(100000).toString(),
      topic: topic,
      type: post.type,
    );

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
        .flatMapResult((_) => postArgumentToAboutTopic())
        .flatMapResult((_) => unregisterArgumentPost(post))
        .mapResult((_) => argument);
  }

  @override
  Future<Result<Void, Never>> registerArgumentPost(EvidenceArgumentPost post) {
    final relatedTopicPost = post.relatedTopic == null
        ? EvidenceTopicPost(id: Random().nextInt(100000).toString(), declaration: post.declaration)
        : null;

    final postWithId = post.copyWith(relatedTopicId: relatedTopicPost?.id);

    return dataSource
        .get(EvidenceArgumentPosts.key)
        .mapResult(EvidenceArgumentPosts.fromJson)
        .onNotFoundReturn(EvidenceArgumentPosts())
        .mapResult((arguments) => arguments.copyWith(arguments: arguments.arguments + [postWithId]))
        .flatMapResult((arguments) => dataSource.put(arguments.toJson(), EvidenceArgumentPosts.key))
        .flatMapResult((_) => relatedTopicPost != null
            ? topicRepository.registerTopicPost(relatedTopicPost)
            : Future.value(Result.success(unit)));
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
