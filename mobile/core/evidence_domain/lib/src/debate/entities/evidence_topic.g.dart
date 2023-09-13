// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evidence_topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvidenceTopic _$EvidenceTopicFromJson(Map<String, dynamic> json) =>
    EvidenceTopic(
      id: json['id'] as String,
      declaration: json['declaration'] as String,
      publisher: EvidenceTopicPublisher.fromJson(
          json['publisher'] as Map<String, dynamic>),
      arguments: (json['arguments'] as List<dynamic>)
          .map((e) => EvidenceArgument.fromJson(e as Map<String, dynamic>))
          .toList(),
      likeCount: json['likeCount'] as int? ?? 0,
    );

Map<String, dynamic> _$EvidenceTopicToJson(EvidenceTopic instance) =>
    <String, dynamic>{
      'id': instance.id,
      'declaration': instance.declaration,
      'publisher': instance.publisher,
      'arguments': instance.arguments,
      'likeCount': instance.likeCount,
    };
