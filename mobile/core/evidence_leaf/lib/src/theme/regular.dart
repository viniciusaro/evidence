import 'package:evidence_leaf/leaf.dart';

mixin LeafTheme {
  static ThemeData regular(LeafSpacingScheme spacingScheme) {
    var data = ThemeData(
      colorSchemeSeed: const Color.fromARGB(255, 112, 86, 0),
      useMaterial3: true,
    );

    data = data.copyWith(
      textTheme: data.textTheme.copyWith(
        labelSmall: data.textTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.w400,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: Size.zero,
          padding: spacingScheme.marginButton,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(spacingScheme.radiusMedium)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: Size.zero,
          padding: spacingScheme.marginButton,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(spacingScheme.radiusMedium)),
        ),
      ),
    );

    return data;
  }
}
