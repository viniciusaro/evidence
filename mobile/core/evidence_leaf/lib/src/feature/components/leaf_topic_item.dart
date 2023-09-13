import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';
import 'package:evidence_foundation_flutter/foundation.dart';

part 'leaf_topic_item.config.dart';

class LeafTopicItem extends StatelessWidget {
  final LeafTopicItemData data;
  final int? maxLines;
  final bool showActionButtons;
  final InteractionCallback? onTap;
  final InteractionCallback? onLikeTap;
  final InteractionCallback? onSupportTap;
  final InteractionCallback? onContestTap;

  const LeafTopicItem({
    super.key,
    required this.data,
    this.maxLines,
    this.showActionButtons = true,
    this.onTap,
    this.onLikeTap,
    this.onSupportTap,
    this.onContestTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textContent = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LeafText(data.title, style: theme.textTheme.bodySmall),
        const LeafSpace(),
        LeafTag(data: data.status.tag(theme)),
        const LeafSpace(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(child: LeafText(data.text, style: theme.textTheme.headlineSmall, maxLines: maxLines)),
            const LeafSpace(axis: Axis.horizontal),
            Icon(
              data.status.icon(theme),
              size: theme.spacingScheme.space5,
              color: data.status.backgroundColor(theme),
            )
          ],
        ),
        const LeafSpace(),
        if (showActionButtons)
          Row(
            children: [
              LeafButton(
                data: const LeafButtonData(title: "👍"),
                onPressed: onLikeTap ?? (_) {},
              ),
              const LeafSpace(axis: Axis.horizontal),
              LeafButton(
                data: const LeafButtonData(title: "Apoiar"),
                onPressed: onSupportTap ?? (_) {},
              ),
              const LeafSpace(axis: Axis.horizontal),
              LeafButton(
                data: const LeafButtonData(title: "Contestar"),
                onPressed: onContestTap ?? (_) {},
              ),
            ],
          ),
      ],
    );

    final arguments = data.arguments.map(
      (argument) => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeafSpace(axis: Axis.horizontal, spacing: theme.spacingScheme.space6),
              Icon(argument.type.icon(theme), size: 16, color: argument.type.iconColor(theme)),
              const LeafSpace(axis: Axis.horizontal),
              Flexible(
                child: LeafText(
                  argument.text,
                  style: theme.textTheme.labelSmall,
                  maxLines: maxLines,
                ),
              ),
            ],
          ),
          const LeafSpace(),
        ],
      ),
    );

    final body = Padding(
      padding: theme.spacingScheme.margin,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeafAvatar(data: data.avatar),
              const LeafSpace(axis: Axis.horizontal),
              Flexible(child: textContent),
            ],
          ),
          if (arguments.isNotEmpty) LeafSpace(spacing: theme.spacingScheme.spaceHalf),
          ...arguments,
        ],
      ),
    );

    return InkWell(
      onTap: onTap?.let((callback) => () => callback(context)),
      child: body,
    );
  }
}
