import 'package:evidence_backend/backend.dart';

import '../integrations.dart';

class HiveIntegration implements AppIntegration {
  const HiveIntegration();

  @override
  Future<AppIntegrationsResult> setUp(AppIntegrationsResult partial) async {
    await Hive.initFlutter();
    final box = await Hive.openBox("HiveKeyJsonDataSource");
    return partial.copyWith(hiveModelBox: box);
  }
}
