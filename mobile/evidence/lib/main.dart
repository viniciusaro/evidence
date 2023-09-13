import 'package:evidence/src/backend/data_source.dart';
import 'package:evidence/src/backend/debate_repository_impl.dart';
import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';

import 'src/screens/home_screen.dart';
import 'src/screens/topic_composition_screen.dart';
import 'src/screens/topic_detail_screen.dart';

part 'main.data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = InMemoryJsonKeyValueDataSource();
    final debateRepository = DebateRepositoryImpl(dataSource: dataSource);

    return MaterialApp(
      title: 'Evidence',
      theme: LeafTheme.regular(LeafSpacingScheme.regular),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings settings) {
        final evidenceRoute = EvidenceRoutes.values.firstWhere(
          (route) => route.routeName == settings.name,
          orElse: () => EvidenceRoutes.defaultRoute,
        );

        switch (evidenceRoute) {
          case EvidenceRoutes.defaultRoute:
            return MaterialPageRoute(builder: (_) => EvidenceHomeScreen(debateRepository: debateRepository));
          case EvidenceRoutes.topicDetail:
            return MaterialPageRoute(builder: (_) => EvidenceTopicDetailScreen(topic: settings.routeArguments()));
          case EvidenceRoutes.topicCompositionModal:
            return ModalBottomSheetRoute(
              builder: (_) => EvidenceTopicCompositionScreen(debateRepository: debateRepository),
              isScrollControlled: true,
              useSafeArea: true,
            );
        }
      },
    );
  }
}

extension on RouteSettings {
  T routeArguments<T>() => arguments as T;
}
