import 'package:evidence_domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'evidence_topic.g.dart';
part 'evidence_topic.extension.dart';

typedef EvidenceTopicId = String;

enum EvidenceTopicStatus {
  debate,
  accepted,
  rejected,
}

@JsonSerializable()
class EvidenceTopic {
  final EvidenceTopicId id;
  final String declaration;
  final EvidenceTopicPublisher publisher;
  final List<EvidenceArgument> arguments;
  final int likeCount;

  const EvidenceTopic({
    required this.id,
    required this.declaration,
    required this.publisher,
    required this.arguments,
    this.likeCount = 0,
  });

  factory EvidenceTopic.fromJson(Map<String, dynamic> json) => _$EvidenceTopicFromJson(json);
  Map<String, dynamic> toJson() => _$EvidenceTopicToJson(this);
}
