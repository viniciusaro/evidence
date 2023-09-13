import 'package:json_annotation/json_annotation.dart';

part 'evidence_topic_publisher.g.dart';

@JsonSerializable()
class EvidenceTopicPublisher {
  final String id;
  final String name;
  final String profilePictureUrl;

  const EvidenceTopicPublisher({
    required this.id,
    required this.name,
    required this.profilePictureUrl,
  });

  factory EvidenceTopicPublisher.fromJson(Map<String, dynamic> json) => _$EvidenceTopicPublisherFromJson(json);
  Map<String, dynamic> toJson() => _$EvidenceTopicPublisherToJson(this);
}
