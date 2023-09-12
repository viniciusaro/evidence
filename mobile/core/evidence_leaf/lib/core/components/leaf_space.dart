import 'package:evidence_leaf/leaf.dart';

class LeafSpace extends StatelessWidget {
  final Axis axis;
  final double? spacing;
  const LeafSpace({super.key, this.axis = Axis.vertical, this.spacing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    switch (axis) {
      case Axis.horizontal:
        return SizedBox(width: spacing ?? theme.spacingScheme.space1);
      case Axis.vertical:
        return SizedBox(height: spacing ?? theme.spacingScheme.space1);
    }
  }
}
