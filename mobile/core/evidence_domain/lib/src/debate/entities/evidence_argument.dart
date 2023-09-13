import 'package:evidence_domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'evidence_argument.freezed.dart';
part 'evidence_argument.g.dart';

enum EvidenceArgumentType {
  inFavor,
  against,
}

@freezed
class EvidenceArgument with _$EvidenceArgument {
  const factory EvidenceArgument({
    required EvidenceTopic topic,
    required EvidenceArgumentType type,
  }) = _EvidenceArgument;

  factory EvidenceArgument.fromJson(Map<String, dynamic> json) => _$EvidenceArgumentFromJson(json);
}
