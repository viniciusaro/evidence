// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evidence_argument.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvidenceArgument _$EvidenceArgumentFromJson(Map<String, dynamic> json) =>
    EvidenceArgument(
      topic: EvidenceTopic.fromJson(json['topic'] as Map<String, dynamic>),
      type: $enumDecode(_$EvidenceArgumentTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$EvidenceArgumentToJson(EvidenceArgument instance) =>
    <String, dynamic>{
      'topic': instance.topic,
      'type': _$EvidenceArgumentTypeEnumMap[instance.type]!,
    };

const _$EvidenceArgumentTypeEnumMap = {
  EvidenceArgumentType.inFavor: 'inFavor',
  EvidenceArgumentType.against: 'against',
};
