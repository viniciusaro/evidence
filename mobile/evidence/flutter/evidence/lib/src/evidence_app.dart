import 'package:evidence_backend/backend.dart' as backend;
import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';

import 'integrations/integrations.dart';

import 'screens/argument_componsition_screen.dart';
import 'screens/home_screen.dart';
import 'screens/topic_composition_screen.dart';
import 'screens/topic_detail_screen.dart';

class EvidenceApp extends StatefulWidget {
  final AppIntegrationsResult appIntegrationsResult;

  const EvidenceApp({super.key, required this.appIntegrationsResult});

  @override
  State<EvidenceApp> createState() => _EvidenceState();
}

class _EvidenceState extends State<EvidenceApp> {
  late backend.Repositories repositories;

  @override
  void initState() {
    super.initState();
    repositories = backend.repositories(widget.appIntegrationsResult.hiveModelBox!);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evidence',
      theme: widget.appIntegrationsResult.themeData,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    switch (settings.route) {
      case EvidenceRoutes.defaultRoute:
        return _defaultRoute(settings);
      case EvidenceRoutes.topicDetail:
        return _topicDetailRoute(settings);
      case EvidenceRoutes.topicCompositionModal:
        return _topicCompositionModalRoute(settings);
      case EvidenceRoutes.inFavorArgumentCompositionModal:
        return _inFavorArgumentCompositionModalRoute(settings);
      case EvidenceRoutes.againstArgumentCompositionModal:
        return _againstArgumentCompositionModalRoute(settings);
    }
  }

  Route _defaultRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => EvidenceHomeScreen(
        argumentRepository: repositories.argumentRepository,
        topicRepository: repositories.topicRepository,
      ),
    );
  }

  Route _topicDetailRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => EvidenceTopicDetailScreen(
        topicRepository: repositories.topicRepository,
        topicId: settings.routeArguments(),
      ),
    );
  }

  Route _topicCompositionModalRoute(RouteSettings settings) {
    return ModalBottomSheetRoute(
      builder: (_) => EvidenceTopicCompositionScreen(topicRepository: repositories.topicRepository),
      isScrollControlled: true,
      useSafeArea: true,
    );
  }

  Route _inFavorArgumentCompositionModalRoute(RouteSettings settings) {
    return ModalBottomSheetRoute(
      builder: (_) => EvidenceArgumentCompositionScreen(
        argumentRepository: repositories.argumentRepository,
        topic: settings.routeArguments(),
        type: EvidenceArgumentType.inFavor,
      ),
      isScrollControlled: true,
      useSafeArea: true,
    );
  }

  Route _againstArgumentCompositionModalRoute(RouteSettings settings) {
    return ModalBottomSheetRoute(
      builder: (_) => EvidenceArgumentCompositionScreen(
        argumentRepository: repositories.argumentRepository,
        topic: settings.routeArguments(),
        type: EvidenceArgumentType.against,
      ),
      isScrollControlled: true,
      useSafeArea: true,
    );
  }
}

extension on RouteSettings {
  T routeArguments<T>() => arguments as T;

  EvidenceRoutes get route => EvidenceRoutes.values.firstWhere(
        (route) => route.routeName == name,
        orElse: () => EvidenceRoutes.defaultRoute,
      );
}
