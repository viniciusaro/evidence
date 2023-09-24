import 'package:evidence_backend/backend.dart';
import 'package:evidence_leaf/leaf.dart';

import 'integrations/hive_consistency_manager_integration.dart';
import 'integrations/hive_integration.dart';
import 'integrations/theme_integration.dart';

part 'integrations.interface.dart';

const integrations = [
  HiveIntegration(),
  HiveConsistencyManagerIntegration(),
  ThemeIntegration(),
];
