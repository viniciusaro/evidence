import 'package:evidence_leaf/leaf.dart';

part 'leaf_tag.config.dart';

class LeafTag extends StatelessWidget {
  final LeafTagData data;

  const LeafTag({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.all(theme.spacingScheme.radiusSmall);

    return Container(
      decoration: BoxDecoration(borderRadius: borderRadius, color: data.color),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Padding(
          padding: theme.spacingScheme.marginTag,
          child: LeafText(
            data.text,
            style: theme.textTheme.bodySmall?.copyWith(color: data.textColor),
          ),
        ),
      ),
    );
  }
}
