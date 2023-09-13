import 'package:evidence_leaf/leaf.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'integrations/hive_integration.dart';
import 'integrations/theme_integration.dart';

part 'integrations.interface.dart';

const integrations = [
  HiveIntegration(),
  ThemeIntegration(),
];
