part of 'integrations.dart';

mixin AppIntegration {
  Future<AppIntegrationsResult> setUp(AppIntegrationsResult partial);
}

class AppIntegrationsResult {
  final Box? hiveModelBox;
  final ThemeData? themeData;

  AppIntegrationsResult({this.hiveModelBox, this.themeData});

  AppIntegrationsResult copyWith({Box? hiveModelBox, ThemeData? themeData}) {
    return AppIntegrationsResult(
      hiveModelBox: hiveModelBox ?? this.hiveModelBox,
      themeData: themeData ?? this.themeData,
    );
  }
}
