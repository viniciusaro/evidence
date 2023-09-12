part of 'leaf_thread_card.dart';

enum LeafThreadCardStatus {
  debate,
  accepted,
  rejected,
}

enum LeafThreadCardArgumentType {
  inFavor,
  against,
}

class LeafThreadCardData {
  final String title;
  final String text;
  final LeafAvatarData avatar;
  final LeafThreadCardStatus status;
  final List<LeafThreadCardArgumentData> arguments;

  const LeafThreadCardData({
    required this.title,
    required this.text,
    required this.avatar,
    required this.status,
    required this.arguments,
  });
}

class LeafThreadCardArgumentData {
  final LeafThreadCardArgumentType type;
  final String text;
  const LeafThreadCardArgumentData({required this.type, required this.text});
}

extension on LeafThreadCardStatus {
  Color iconColor(ThemeData theme) {
    switch (this) {
      case LeafThreadCardStatus.debate:
        return theme.colorScheme.outline;
      case LeafThreadCardStatus.accepted:
        return theme.colorScheme.outline;
      case LeafThreadCardStatus.rejected:
        return theme.colorScheme.outline;
    }
  }

  IconData icon(ThemeData theme) {
    switch (this) {
      case LeafThreadCardStatus.debate:
        return Iconsax.messages_3;
      case LeafThreadCardStatus.accepted:
        return Iconsax.messages_3;
      case LeafThreadCardStatus.rejected:
        return Iconsax.messages_3;
    }
  }

  LeafTagData tag(ThemeData theme) {
    switch (this) {
      case LeafThreadCardStatus.debate:
        return const LeafTagData(status: LeafTagStatus.debate);
      case LeafThreadCardStatus.accepted:
        return const LeafTagData(status: LeafTagStatus.accepted);
      case LeafThreadCardStatus.rejected:
        return const LeafTagData(status: LeafTagStatus.rejected);
    }
  }
}

extension on LeafThreadCardArgumentType {
  Color iconColor(ThemeData theme) {
    switch (this) {
      case LeafThreadCardArgumentType.inFavor:
        return theme.colorScheme.primary;
      case LeafThreadCardArgumentType.against:
        return theme.colorScheme.tertiary;
    }
  }

  IconData icon(ThemeData theme) {
    switch (this) {
      case LeafThreadCardArgumentType.inFavor:
        return Iconsax.message_add_15;
      case LeafThreadCardArgumentType.against:
        return Iconsax.message_minus5;
    }
  }
}
