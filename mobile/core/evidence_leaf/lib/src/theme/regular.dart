import 'package:evidence_leaf/leaf.dart';

mixin LeafTheme {
  static ThemeData get regular {
    var data = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      useMaterial3: true,
    );

    data = data.copyWith(
      textTheme: data.textTheme.copyWith(
        labelSmall: data.textTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.w400,
        ),
      ),
      appBarTheme: data.appBarTheme.copyWith(
        actionsIconTheme: data.appBarTheme.actionsIconTheme?.copyWith(size: 10, opticalSize: 20),
        iconTheme: data.appBarTheme.iconTheme?.copyWith(size: 10, opticalSize: 20),
      ),
    );

    return data;
  }
}
