import 'package:evidence_leaf/leaf.dart';

part 'leaf_topic_argument_item.config.dart';

class LeafTopicArgumentItem extends StatelessWidget {
  final LeafTopicArgumentItemData data;

  const LeafTopicArgumentItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final body = Padding(
      padding: theme.spacingScheme.margin,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeafAvatar(data: data.avatar, size: LeafAvatarSize.small),
          const LeafSpace(axis: Axis.horizontal),
          Flexible(child: LeafText(data.text, style: theme.textTheme.bodySmall)),
        ],
      ),
    );

    return InkWell(
      // onTap: onTap?.let((callback) => () => callback(context)),
      child: body,
    );
  }
}
