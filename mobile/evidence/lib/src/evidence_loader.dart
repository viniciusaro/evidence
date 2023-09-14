import 'package:flutter/material.dart';

import 'integrations/integrations.dart';

class EvidenceLoader extends StatefulWidget {
  final List<AppIntegration> integrations;
  final Widget Function(AppIntegrationsResult result) onResult;

  const EvidenceLoader({
    super.key,
    required this.integrations,
    required this.onResult,
  });

  @override
  State<EvidenceLoader> createState() => _EvidenceLoaderState();
}

class _EvidenceLoaderState extends State<EvidenceLoader> {
  Future<AppIntegrationsResult> _foldIntegrations() async {
    var integrationResult = AppIntegrationsResult();
    for (final integration in widget.integrations) {
      integrationResult = await integration.setUp(integrationResult);
    }
    return integrationResult;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _foldIntegrations(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return widget.onResult(snapshot.requireData);
        }
        return Container(color: Colors.white);
      },
    );
  }
}
