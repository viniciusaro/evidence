part of 'leaf_topic_item.dart';

enum LeafTopicItemStatus {
  debate,
  accepted,
  rejected,
}

enum LeafTopicItemArgumentType {
  inFavor,
  against,
}

class LeafTopicItemData {
  final String title;
  final String text;
  final LeafAvatarData avatar;
  final LeafTopicItemStatus status;
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
  final LeafTopicItemArgumentType type;
  final String text;
  const LeafTopicItemArgumentData({required this.type, required this.text});
}

extension on LeafTopicItemStatus {
  Color iconColor(ThemeData theme) {
    switch (this) {
      case LeafTopicItemStatus.debate:
        return theme.colorScheme.outline;
      case LeafTopicItemStatus.accepted:
        return theme.colorScheme.outline;
      case LeafTopicItemStatus.rejected:
        return theme.colorScheme.outline;
    }
  }

  IconData icon(ThemeData theme) {
    switch (this) {
      case LeafTopicItemStatus.debate:
        return Iconsax.messages_3;
      case LeafTopicItemStatus.accepted:
        return Iconsax.messages_3;
      case LeafTopicItemStatus.rejected:
        return Iconsax.messages_3;
    }
  }

  LeafTagData tag(ThemeData theme) {
    switch (this) {
      case LeafTopicItemStatus.debate:
        return const LeafTagData(status: LeafTagStatus.debate);
      case LeafTopicItemStatus.accepted:
        return const LeafTagData(status: LeafTagStatus.accepted);
      case LeafTopicItemStatus.rejected:
        return const LeafTagData(status: LeafTagStatus.rejected);
    }
  }
}

extension on LeafTopicItemArgumentType {
  Color iconColor(ThemeData theme) {
    switch (this) {
      case LeafTopicItemArgumentType.inFavor:
        return theme.colorScheme.primary;
      case LeafTopicItemArgumentType.against:
        return theme.colorScheme.tertiary;
    }
  }

  IconData icon(ThemeData theme) {
    switch (this) {
      case LeafTopicItemArgumentType.inFavor:
        return Iconsax.message_add_15;
      case LeafTopicItemArgumentType.against:
        return Iconsax.message_minus5;
    }
  }
}
