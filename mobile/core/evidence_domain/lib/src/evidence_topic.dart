import 'package:evidence_domain/domain.dart';

enum EvidenceTopicStatus {
  debate,
  accepted,
  rejected,
}

class EvidenceTopic {
  final String declaration;
  final EvidenceTopicPublisher publisher;
  final EvidenceTopicStatus status;
  final List<EvidenceArgument> arguments;

  const EvidenceTopic({
    required this.declaration,
    required this.publisher,
    required this.status,
    required this.arguments,
  });
}
