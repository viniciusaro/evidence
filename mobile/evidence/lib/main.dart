import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';

import 'src/screens/home_screen.dart';
import 'src/screens/topic_detail_screen.dart';

part 'main.data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
            return MaterialPageRoute(builder: (_) => const EvidenceHomeScreen(topics: topics));
          case EvidenceRoutes.topicDetail:
            return MaterialPageRoute(builder: (_) => EvidenceTopicDetailScreen(topic: settings.routeArguments()));
        }
      },
    );
  }
}

extension on RouteSettings {
  T routeArguments<T>() => arguments as T;
}
