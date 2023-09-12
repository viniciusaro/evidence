part of 'leaf_topic_argument_item.dart';

enum LeafTopicArgumentItemType {
  inFavor,
  against,
}

enum LeafTopicArgumentItemStatus {
  debate,
  accepted,
  rejected,
}

class LeafTopicArgumentItemData {
  final LeafTopicArgumentItemType type;
  final LeafTopicArgumentItemStatus status;
  final LeafAvatarData avatar;
  final String text;

  const LeafTopicArgumentItemData({
    required this.type,
    required this.status,
    required this.text,
    required this.avatar,
  });
}

extension on LeafTopicArgumentItemStatus {
  Color iconColor(ThemeData theme) {
    switch (this) {
      case LeafTopicArgumentItemStatus.debate:
        return theme.colorScheme.outline;
      case LeafTopicArgumentItemStatus.accepted:
        return theme.colorScheme.primary;
      case LeafTopicArgumentItemStatus.rejected:
        return theme.colorScheme.tertiary;
    }
  }

  IconData icon(ThemeData theme) {
    switch (this) {
      case LeafTopicArgumentItemStatus.debate:
        return Iconsax.messages_35;
      case LeafTopicArgumentItemStatus.accepted:
        return Iconsax.verify5;
      case LeafTopicArgumentItemStatus.rejected:
        return Iconsax.close_square5;
    }
  }

  LeafTagData tag(ThemeData theme) {
    switch (this) {
      case LeafTopicArgumentItemStatus.debate:
        return const LeafTagData(status: LeafTagStatus.debate);
      case LeafTopicArgumentItemStatus.accepted:
        return const LeafTagData(status: LeafTagStatus.accepted);
      case LeafTopicArgumentItemStatus.rejected:
        return const LeafTagData(status: LeafTagStatus.rejected);
    }
  }
}
