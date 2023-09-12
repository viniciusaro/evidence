import 'package:evidence_domain/domain.dart';
import 'package:evidence_foundation_flutter/foundation.dart';
import 'package:evidence_leaf/leaf.dart';

part 'leaf_topic_argument_item.config.dart';

class LeafTopicArgumentItem extends StatelessWidget {
  final LeafTopicArgumentItemData data;
  final InteractionCallback? onTap;

  const LeafTopicArgumentItem({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final statusIcon = Icon(
      data.status.icon(theme),
      size: theme.spacingScheme.space3,
      color: data.status.backgroundColor(theme),
    );

    final text = LeafText(
      data.text,
      style: theme.textTheme.bodyMedium?.copyWith(color: data.status.foregroundColor(theme)),
    );

    final typeIcon = Icon(
      data.type.icon(theme),
      size: theme.spacingScheme.space3,
      color: data.type.iconColor(theme),
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
                text,
                const LeafSpace(),
                Row(children: [
                  const LeafSpace(axis: Axis.horizontal),
                  typeIcon,
                  statusIcon,
                ]),
              ],
            ),
          ),
        ],
      ),
    );

    return InkWell(
      onTap: onTap?.let((callback) => () => callback(context)),
      child: body,
    );
  }
}
