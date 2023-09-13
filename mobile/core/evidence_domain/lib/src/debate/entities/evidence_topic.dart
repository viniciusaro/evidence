import 'package:evidence_domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'evidence_topic.extension.dart';
part 'evidence_topic.freezed.dart';
part 'evidence_topic.g.dart';

typedef EvidenceTopicId = String;

enum EvidenceTopicStatus {
  debate,
  accepted,
  rejected,
}

@freezed
class EvidenceTopics with _$EvidenceTopics {
  static String key = "EvidenceTopics";

  const factory EvidenceTopics({
    @Default([]) List<EvidenceTopic> topics,
  }) = _EvidenceTopics;

  factory EvidenceTopics.fromJson(Map<String, dynamic> json) => _$EvidenceTopicsFromJson(json);
}

@freezed
class EvidenceTopic with _$EvidenceTopic {
  static String key = "EvidenceTopic";

  const factory EvidenceTopic({
    required EvidenceTopicId id,
    required String declaration,
    required EvidenceTopicPublisher publisher,
    required List<EvidenceArgument> arguments,
    @Default(0) int likeCount,
  }) = _EvidenceTopic;

  factory EvidenceTopic.fromJson(Map<String, dynamic> json) => _$EvidenceTopicFromJson(json);
}
