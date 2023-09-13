import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';

import 'src/evidence_app.dart';
import 'src/evidence_loader.dart';
import 'src/integrations/integrations.dart';

part 'main.data.dart';

void main() {
  runApp(
    EvidenceLoader(
      integrations: integrations,
      onResult: (appIntegrationsResult) => EvidenceApp(appIntegrationsResult: appIntegrationsResult),
    ),
  );
}
