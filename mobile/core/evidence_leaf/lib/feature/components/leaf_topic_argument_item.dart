import 'package:evidence_foundation_flutter/foundation.dart';
import 'package:evidence_leaf/leaf.dart';
import 'package:iconsax/iconsax.dart';

part 'leaf_topic_argument_item.config.dart';

class LeafTopicArgumentItem extends StatelessWidget {
  final LeafTopicArgumentItemData data;
  final InteractionCallback? onTap;

  const LeafTopicArgumentItem({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final icon = Column(
      children: [
        const LeafSpace(),
        Icon(data.status.icon(theme), size: theme.spacingScheme.space3, color: data.status.iconColor(theme)),
      ],
    );

    final body = Padding(
      padding: theme.spacingScheme.margin,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeafAvatar(data: data.avatar, size: LeafAvatarSize.small),
          const LeafSpace(axis: Axis.horizontal),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LeafText(data.text, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const LeafSpace(axis: Axis.horizontal),
          icon,
        ],
      ),
    );

    return InkWell(
      onTap: onTap?.let((callback) => () => callback(context)),
      child: body,
    );
  }
}
