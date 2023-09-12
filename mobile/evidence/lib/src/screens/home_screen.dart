import 'dart:math';

import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';

class EvidenceHomeScreen extends StatelessWidget {
  final List<EvidenceTopic> topics;

  const EvidenceHomeScreen({super.key, required this.topics});

  @override
  Widget build(BuildContext context) {
    final items = topics.map((topic) {
      final arguments = topic.arguments.getRange(0, max(0, min(2, topic.arguments.length))).map(
            (argument) => LeafTopicItemArgumentData(
              text: argument.topic.declaration,
              type: argument.type,
            ),
          );

      return LeafTopicItem(
        onTap: (context) => Navigator.of(context).pushNamed(EvidenceRoutes.topicDetail.routeName, arguments: topic),
        data: LeafTopicItemData(
          title: topic.publisher.name,
          text: topic.declaration,
          status: topic.status,
          avatar: LeafAvatarData(url: topic.publisher.profilePictureUrl),
          arguments: arguments.toList(),
        ),
        maxLines: 5,
      );
    }).toList();

    return LeafScaffold(
      appBar: LeafAppBar(data: LeafAppBarData.title('🌳')),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return items[index];
        },
        separatorBuilder: (context, index) {
          return const LeafSeparator();
        },
        itemCount: items.length,
      ),
    );
  }
}
