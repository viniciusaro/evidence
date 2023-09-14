import 'package:evidence/backend/data_source.dart';
import 'package:evidence/backend/debate_repository_impl.dart';
import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';

import 'integrations/integrations.dart';
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
  late DebateRepository debateRepository;

  @override
  void initState() {
    super.initState();
    final dataSource = HiveKeyJsonDataSource(widget.appIntegrationsResult.hiveModelBox!);
    debateRepository = DebateRepositoryImpl(dataSource: dataSource);
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
    }
  }

  Route _defaultRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => EvidenceHomeScreen(debateRepository: debateRepository));
  }

  Route _topicDetailRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => EvidenceTopicDetailScreen(
        debateRepository: debateRepository,
        topicId: settings.routeArguments(),
      ),
    );
  }

  Route _topicCompositionModalRoute(RouteSettings settings) {
    return ModalBottomSheetRoute(
      builder: (_) => EvidenceTopicCompositionScreen(debateRepository: debateRepository),
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
