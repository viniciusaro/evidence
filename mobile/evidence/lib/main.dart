import 'package:evidence_leaf/leaf.dart';

import 'src/screens/home_screen.dart';
import 'src/screens/topic_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

mixin EvidenceRoutes {
  static const defaultRouteName = Navigator.defaultRouteName;
  static const topicDetailRouteName = "topicDetail";
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
        EvidenceRoutes.defaultRouteName: (context) => const EvidenceHomeScreen(),
        EvidenceRoutes.topicDetailRouteName: (context) => EvidenceTopicDetailScreen(id: context.routeArguments()),
      },
    );
  }
}

extension on BuildContext {
  T routeArguments<T>() => ModalRoute.of(this)!.settings.arguments as T;
}
