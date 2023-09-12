part of 'leaf_topic_item.dart';

class LeafTopicItemData {
  final String title;
  final String text;
  final LeafAvatarData avatar;
  final EvidenceTopicStatus status;
  final List<LeafTopicItemArgumentData> arguments;

  const LeafTopicItemData({
    required this.title,
    required this.text,
    required this.avatar,
    required this.status,
    this.arguments = const [],
  });
}

class LeafTopicItemArgumentData {
  final EvidenceArgumentType type;
  final String text;
  const LeafTopicItemArgumentData({required this.type, required this.text});
}
