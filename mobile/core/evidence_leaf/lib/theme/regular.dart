import 'package:evidence_leaf/leaf.dart';

mixin LeafTheme {
  static ThemeData get regular {
    var data = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      useMaterial3: true,
    );

    data = data.copyWith(
      textTheme: data.textTheme.copyWith(
        labelSmall: data.textTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    return data;
  }
}
