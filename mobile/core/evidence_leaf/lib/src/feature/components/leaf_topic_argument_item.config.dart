part of 'leaf_topic_argument_item.dart';

class LeafTopicArgumentItemData {
  final EvidenceArgumentType type;
  final EvidenceTopicStatus status;
  final LeafAvatarData avatar;
  final String text;

  const LeafTopicArgumentItemData({
    required this.type,
    required this.status,
    required this.text,
    required this.avatar,
  });
}
