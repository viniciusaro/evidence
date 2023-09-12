part of 'leaf_topic_argument_item.dart';

enum LeafTopicArgumentItemType {
  inFavor,
  against,
}

class LeafTopicArgumentItemData {
  final LeafTopicArgumentItemType type;
  final LeafAvatarData avatar;
  final String text;
  const LeafTopicArgumentItemData({required this.type, required this.text, required this.avatar});
}
