import 'package:evidence_leaf/leaf.dart';
import 'package:flutter/foundation.dart';

import '../integrations.dart';

class ThemeIntegration with AppIntegration {
  const ThemeIntegration();

  @override
  Future<AppIntegrationsResult> setUp(AppIntegrationsResult partial) {
    return SynchronousFuture(
      partial.copyWith(
        themeData: LeafTheme.regular(LeafSpacingScheme.regular),
      ),
    );
  }
}
