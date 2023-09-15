import 'package:evidence_backend/backend.dart';
import 'package:flutter/foundation.dart';

import '../integrations.dart';

class HiveConsistencyManagerIntegration with AppIntegration {
  const HiveConsistencyManagerIntegration();

  @override
  Future<AppIntegrationsResult> setUp(AppIntegrationsResult partial) {
    HiveConsistencyManager(box: partial.hiveModelBox!).run();
    return SynchronousFuture(partial);
  }
}
