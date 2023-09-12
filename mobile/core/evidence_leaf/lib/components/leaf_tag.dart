import 'package:evidence_leaf/leaf.dart';

enum LeafTagStatus {
  debate,
  accepted,
  rejected,
}

extension on LeafTagStatus {
  Color color(ThemeData theme) {
    switch (this) {
      case LeafTagStatus.debate:
        return theme.colorScheme.outline;
      case LeafTagStatus.accepted:
        return theme.colorScheme.outline;
      case LeafTagStatus.rejected:
        return theme.colorScheme.outline;
    }
  }

  Color textColor(ThemeData theme) {
    switch (this) {
      case LeafTagStatus.debate:
        return theme.colorScheme.onPrimary;
      case LeafTagStatus.accepted:
        return theme.colorScheme.onPrimary;
      case LeafTagStatus.rejected:
        return theme.colorScheme.onPrimary;
    }
  }

  String text(ThemeData theme) {
    switch (this) {
      case LeafTagStatus.debate:
        return "Em debate";
      case LeafTagStatus.accepted:
        return "Aceito";
      case LeafTagStatus.rejected:
        return "Rejetado";
    }
  }
}

class LeafTagData {
  final LeafTagStatus status;
  const LeafTagData({required this.status});
}

class LeafTag extends StatelessWidget {
  final LeafTagData data;

  const LeafTag({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.all(theme.spacingScheme.radiusSmall);

    return Container(
      decoration: BoxDecoration(borderRadius: borderRadius, color: data.status.color(theme)),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Padding(
          padding: theme.spacingScheme.marginTag,
          child: LeafText(
            data.status.text(theme),
            style: theme.textTheme.bodySmall?.copyWith(color: data.status.textColor(theme)),
          ),
        ),
      ),
    );
  }
}
