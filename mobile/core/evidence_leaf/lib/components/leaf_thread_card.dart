import 'package:evidence_leaf/leaf.dart';
import 'package:iconsax/iconsax.dart';

enum LeafThreadCardStatus {
  debate,
  accepted,
  rejected,
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

enum LeafThreadCardArgumentType {
  inFavor,
  against,
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

class LeafThreadCard extends StatelessWidget {
  final LeafThreadCardData data;
  const LeafThreadCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final arguments = data.arguments.map(
      (argument) => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeafSpace(axis: Axis.horizontal, spacing: theme.spacingScheme.space5),
              Icon(argument.type.icon(theme), size: 16, color: argument.type.iconColor(theme)),
              const LeafSpace(axis: Axis.horizontal),
              Flexible(
                child: LeafText(
                  argument.text,
                  style: theme.textTheme.labelSmall,
                ),
              ),
            ],
          ),
          const LeafSpace(),
        ],
      ),
    );

    final textContent = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LeafText(data.title, style: theme.textTheme.bodySmall),
        LeafText(data.text, style: theme.textTheme.headlineSmall),
        const LeafSpace(),
        LeafTag(data: data.status.tag(theme)),
      ],
    );

    final icon = Column(
      children: [
        LeafSpace(spacing: theme.spacingScheme.space4),
        Icon(data.status.icon(theme), size: theme.spacingScheme.space4, color: data.status.iconColor(theme)),
      ],
    );

    return Padding(
      padding: theme.spacingScheme.margin,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeafAvatar(data: data.avatar),
              const LeafSpace(axis: Axis.horizontal),
              Flexible(child: textContent),
              icon,
            ],
          ),
          const LeafSpace(),
          const LeafSpace(),
          ...arguments,
        ],
      ),
    );
  }
}
