import 'package:evidence_domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'evidence_argument.freezed.dart';
part 'evidence_argument.g.dart';

enum EvidenceArgumentType {
  inFavor,
  against,
}

@freezed
class EvidenceArguments with _$EvidenceArguments {
  static const key = "EvidenceArguments";

  const factory EvidenceArguments({
    @Default([]) List<EvidenceArgument> arguments,
  }) = _EvidenceArguments;

  factory EvidenceArguments.fromJson(Map<String, dynamic> json) => _$EvidenceArgumentsFromJson(json);
}

@freezed
class EvidenceArgument with _$EvidenceArgument {
  static const key = "EvidenceArgument";

  const factory EvidenceArgument({
    required String id,
    required EvidenceTopic topic,
    required EvidenceArgumentType type,
    @Default(0) int likeCount,
  }) = _EvidenceArgument;

  factory EvidenceArgument.fromJson(Map<String, dynamic> json) => _$EvidenceArgumentFromJson(json);
}

extension EvidenceArgumentString on EvidenceArgument {
  String customToString() {
    return """
EvidenceArgument id: $id, 
  likeCount: $likeCount,
  topic: ${topic.customToString()}
""";
  }
}
