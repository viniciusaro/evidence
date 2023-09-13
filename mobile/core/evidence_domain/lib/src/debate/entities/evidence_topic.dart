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
class EvidenceTopic with _$EvidenceTopic {
  const factory EvidenceTopic({
    required EvidenceTopicId id,
    required String declaration,
    required EvidenceTopicPublisher publisher,
    required List<EvidenceArgument> arguments,
    @Default(0) int likeCount,
  }) = _EvidenceTopic;

  factory EvidenceTopic.fromJson(Map<String, dynamic> json) => _$EvidenceTopicFromJson(json);
}
