import 'package:evidence_leaf/leaf.dart';
import 'package:iconsax/iconsax.dart';

part 'leaf_thread_card.config.dart';

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
