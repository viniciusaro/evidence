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
      theme: LeafTheme.regular,
      debugShowCheckedModeBanner: false,
      routes: {
        EvidenceRoutes.defaultRoute.routeName: (context) => //
            const EvidenceHomeScreen(topics: topics),
        EvidenceRoutes.topicDetail.routeName: (context) => //
            EvidenceTopicDetailScreen(topic: context.routeArguments()),
      },
    );
  }
}

extension on BuildContext {
  T routeArguments<T>() => ModalRoute.of(this)!.settings.arguments as T;
}
