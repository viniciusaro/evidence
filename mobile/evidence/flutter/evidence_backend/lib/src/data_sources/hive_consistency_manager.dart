part of 'data_source.dart';

class HiveConsistencyManager {
  final Box box;

  HiveConsistencyManager({required this.box});

  void run() {
    final topicsListenable = box.listenable(keys: [EvidenceTopics.key]);

    EvidenceTopics topics = box.getJSON(EvidenceTopics.key, defaultValue: {}).let(EvidenceTopics.fromJson);

    topicsListenable.addListener(() {
      topics = topicsListenable.value.getJSON(EvidenceTopics.key).let(EvidenceTopics.fromJson);

      final newTopics = topics.topics.map((topic) {
        final arguments = topic.arguments.map((argument) {
          return topics.topics.firstWhereOrNull((topic) => topic.id == argument.topic.id)?.let((topic) {
                final updated = argument.copyWith(topic: topic);
                return updated != argument ? updated : argument;
              }) ??
              argument;
        }).toList();
        if (!listEquals(arguments, topic.arguments)) {
          return topic.copyWith(arguments: arguments);
        }
        return topic;
      }).toList();

      if (!listEquals(newTopics, topics.topics)) {
        box.put(EvidenceTopics.key, EvidenceTopics(topics: newTopics).toJson());
      }
    });
  }
}
