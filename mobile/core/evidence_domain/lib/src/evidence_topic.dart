import 'package:evidence_domain/domain.dart';

enum EvidenceTopicStatus {
  debate,
  accepted,
  rejected,
}

class EvidenceTopic {
  final String declaration;
  final EvidenceTopicPublisher publisher;
  final List<EvidenceArgument> arguments;
  final int likeCount;

  const EvidenceTopic({
    required this.declaration,
    required this.publisher,
    required this.arguments,
    this.likeCount = 0,
  });

  EvidenceTopicStatus get status {
    final minimumArgumentsCount = 10;
    final inFavorArgumentCount = arguments.where((a) => a.type == EvidenceArgumentType.inFavor).length;
    final againstArgumentCount = arguments.where((a) => a.type == EvidenceArgumentType.against).length;
    final acceptanceRate = inFavorArgumentCount / arguments.length;
    final rejectionRate = againstArgumentCount / arguments.length;
    final likeRate = likeCount / arguments.length;

    if (arguments.length >= minimumArgumentsCount && acceptanceRate > 0.9) {
      return EvidenceTopicStatus.accepted;
    }
    if (arguments.length >= minimumArgumentsCount && rejectionRate > 0.9) {
      return EvidenceTopicStatus.rejected;
    }
    if (likeRate > 0.95) {
      return EvidenceTopicStatus.accepted;
    }
    return EvidenceTopicStatus.debate;
  }
}
