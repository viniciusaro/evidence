import 'package:evidence_domain/domain.dart';

enum EvidenceArgumentType {
  inFavor,
  against,
}

class EvidenceArgument {
  final EvidenceTopic topic;
  final EvidenceArgumentType type;
  const EvidenceArgument({required this.topic, required this.type});
}
