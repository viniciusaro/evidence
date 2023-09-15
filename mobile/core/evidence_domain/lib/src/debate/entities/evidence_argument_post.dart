import 'package:evidence_domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'evidence_argument_post.freezed.dart';
part 'evidence_argument_post.g.dart';

@freezed
class EvidenceArgumentPosts with _$EvidenceArgumentPosts {
  static const key = "EvidenceArgumentPosts";

  const factory EvidenceArgumentPosts({
    @Default([]) List<EvidenceArgumentPost> arguments,
  }) = _EvidenceArgumentPosts;

  factory EvidenceArgumentPosts.fromJson(Map<String, dynamic> json) => _$EvidenceArgumentPostsFromJson(json);
}

@freezed
class EvidenceArgumentPost with _$EvidenceArgumentPost {
  static const key = "EvidenceArgumentPost";

  const factory EvidenceArgumentPost({
    required EvidenceTopic aboutTopic,
    required EvidenceArgumentType type,
    required String declaration,
  }) = _EvidenceArgumentPost;

  factory EvidenceArgumentPost.fromJson(Map<String, dynamic> json) => _$EvidenceArgumentPostFromJson(json);
}
