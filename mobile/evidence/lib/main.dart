import 'package:evidence/src/backend/data_source.dart';
import 'package:evidence/src/backend/debate_repository_impl.dart';
import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/screens/home_screen.dart';
import 'src/screens/topic_composition_screen.dart';
import 'src/screens/topic_detail_screen.dart';

part 'main.data.dart';

void main() async {
  await Hive.initFlutter();
  final box = await Hive.openBox("HiveKeyJsonDataSource", encryptionCipher: HiveAesCipher(key));
  runApp(MyApp(box: box));
}

class MyApp extends StatelessWidget {
  final Box box;

  const MyApp({super.key, required this.box});

  @override
  Widget build(BuildContext context) {
    final dataSource = HiveKeyJsonDataSource(box);
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

const key = [
  235,
  70,
  149,
  186,
  255,
  171,
  86,
  216,
  229,
  65,
  125,
  223,
  171,
  199,
  30,
  104,
  129,
  150,
  128,
  88,
  198,
  31,
  148,
  165,
  177,
  210,
  74,
  95,
  88,
  92,
  129,
  222
];
