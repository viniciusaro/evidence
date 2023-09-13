import 'package:evidence_leaf/leaf.dart';

class LeafSpacingScheme {
  EdgeInsets get margin => EdgeInsets.all(space2);
  EdgeInsets get marginTag => EdgeInsets.fromLTRB(spaceHalf, spaceHalf * 0.5, spaceHalf, spaceHalf * 0.5);
  EdgeInsets get marginButton => EdgeInsets.fromLTRB(space3, space1 * 0.8, space3, space1 * 0.8);

  final Radius radiusCircular;
  Radius get radiusSmall => Radius.circular(spaceHalf);
  Radius get radiusMedium => Radius.circular(space1);

  final double spaceHalf;
  final double space1;
  final double space2;
  final double space3;
  final double space4;
  final double space5;
  final double space6;
  final double space7;
  final double space8;

  const LeafSpacingScheme({
    required this.radiusCircular,
    required double grid,
  })  : spaceHalf = grid * 0.5,
        space1 = grid,
        space2 = grid * 2,
        space3 = grid * 3,
        space4 = grid * 4,
        space5 = grid * 5,
        space6 = grid * 6,
        space7 = grid * 7,
        space8 = grid * 8;

  static const LeafSpacingScheme regular = LeafSpacingScheme(
    radiusCircular: Radius.circular(1000),
    grid: 8,
  );
}

extension ThemeDataSpacing on ThemeData {
  LeafSpacingScheme get spacingScheme {
    if (this == LeafTheme.regular(LeafSpacingScheme.regular)) {
      return LeafSpacingScheme.regular;
    }
    return LeafSpacingScheme.regular;
  }
}
