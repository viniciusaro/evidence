import 'package:evidence_leaf/leaf.dart';

class LeafSeparator extends StatelessWidget {
  final Axis axis;
  const LeafSeparator({super.key, this.axis = Axis.horizontal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = axis == Axis.horizontal ? 1.0 : double.infinity;
    final width = axis == Axis.vertical ? double.infinity : 1.0;

    return Container(
      width: width,
      height: height,
      color: theme.colorScheme.outlineVariant,
    );
  }
}
