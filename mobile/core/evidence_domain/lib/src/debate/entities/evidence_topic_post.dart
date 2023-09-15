import 'package:freezed_annotation/freezed_annotation.dart';

part 'evidence_topic_post.freezed.dart';
part 'evidence_topic_post.g.dart';

@freezed
class EvidenceTopicPosts with _$EvidenceTopicPosts {
  static const key = "EvidenceTopicPosts";

  const factory EvidenceTopicPosts({
    @Default([]) List<EvidenceTopicPost> topics,
  }) = _EvidenceTopicPosts;

  factory EvidenceTopicPosts.fromJson(Map<String, dynamic> json) => _$EvidenceTopicPostsFromJson(json);
}

@freezed
class EvidenceTopicPost with _$EvidenceTopicPost {
  static const key = "EvidenceTopicPost";

  const factory EvidenceTopicPost({
    String? id,
    required String declaration,
  }) = _EvidenceTopicPost;

  factory EvidenceTopicPost.fromJson(Map<String, dynamic> json) => _$EvidenceTopicPostFromJson(json);
}
