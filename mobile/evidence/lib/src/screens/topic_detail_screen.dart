import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';

class EvidenceTopicDetailScreen extends StatelessWidget {
  final EvidenceTopic topic;

  const EvidenceTopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final topicItem = LeafTopicItem(
      data: LeafTopicItemData(
        title: topic.publisher.name,
        text: topic.declaration,
        status: topic.status,
        avatar: LeafAvatarData(url: topic.publisher.profilePictureUrl),
      ),
    );

    final argumentData = topic.arguments.map((argument) {
      return LeafTopicArgumentItemData(
        type: argument.type,
        status: argument.topic.status,
        text: argument.topic.declaration,
        avatar: LeafAvatarData(url: argument.topic.publisher.profilePictureUrl),
      );
    }).toList();

    return LeafScaffold(
      appBar: LeafAppBar(data: LeafAppBarData.topic()),
      body: ListView.separated(
        itemBuilder: (context, index) {
          if (index == 0) return topicItem;

          return LeafTopicArgumentItem(
            data: argumentData[index - 1],
            onTap: (context) {
              Navigator.of(context).pushNamed(
                EvidenceRoutes.topicDetail.routeName,
                arguments: topic.arguments[index - 1].topic,
              );
            },
          );
        },
        separatorBuilder: (context, index) {
          return const LeafSeparator();
        },
        itemCount: argumentData.length + 1,
      ),
    );
  }
}
