import 'package:freezed_annotation/freezed_annotation.dart';

part 'evidence_topic_publisher.freezed.dart';
part 'evidence_topic_publisher.g.dart';

@freezed
class EvidenceTopicPublisher with _$EvidenceTopicPublisher {
  const factory EvidenceTopicPublisher({
    required String id,
    required String name,
    required String profilePictureUrl,
  }) = _EvidenceTopicPublisher;

  factory EvidenceTopicPublisher.fromJson(Map<String, dynamic> json) => _$EvidenceTopicPublisherFromJson(json);
}
