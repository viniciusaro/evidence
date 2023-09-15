part of 'evidence_topic.dart';

extension EvidenceTopicsExtension on EvidenceTopics {
  EvidenceTopics copyWithNewArgumentForTopic(EvidenceArgument argument, EvidenceTopic topic) {
    return copyWith(
      topics: topics.map((t) {
        if (t.id != topic.id) {
          return t;
        }
        return topic.copyWith(arguments: topic.arguments + [argument]);
      }).toList(),
    );
  }
}

extension EvidenceTopicExtension on EvidenceTopic {
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
