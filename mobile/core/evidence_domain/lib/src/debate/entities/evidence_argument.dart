import 'package:evidence_domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'evidence_argument.g.dart';

enum EvidenceArgumentType {
  inFavor,
  against,
}

@JsonSerializable()
class EvidenceArgument {
  final EvidenceTopic topic;
  final EvidenceArgumentType type;
  const EvidenceArgument({required this.topic, required this.type});

  factory EvidenceArgument.fromJson(Map<String, dynamic> json) => _$EvidenceArgumentFromJson(json);
  Map<String, dynamic> toJson() => _$EvidenceArgumentToJson(this);
}
