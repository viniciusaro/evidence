import 'package:evidence_leaf/leaf.dart';

class EvidenceTopicDetailScreen extends StatelessWidget {
  final String id;

  const EvidenceTopicDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final topic = LeafTopicItem(
      onTap: (context) => Navigator.of(context).pushNamed("topicDetail", arguments: "id"),
      data: const LeafTopicItemData(
        title: "Vini Rodrigues",
        text: "Não se deve dar dinheiro para crianças pedintes na rua.",
        status: LeafTopicItemStatus.debate,
        avatar: LeafAvatarData(
          url: "https://pbs.twimg.com/profile_images/1584303098687885312/SljBjw26_400x400.jpg",
        ),
      ),
    );

    const argumentData = [
      LeafTopicArgumentItemData(
        type: LeafTopicArgumentItemType.inFavor,
        text: "O dinheiro não fará diferença pra quem está dando, mas fará diferença para quem está recebendo",
        avatar: LeafAvatarData(
          url: "https://pbs.twimg.com/profile_images/1584303098687885312/SljBjw26_400x400.jpg",
        ),
      ),
      LeafTopicArgumentItemData(
        type: LeafTopicArgumentItemType.against,
        text: "Esta prática incentiva o trabalho infantil, que deve ser erradicado",
        avatar: LeafAvatarData(
          url: "https://pbs.twimg.com/profile_images/1584303098687885312/SljBjw26_400x400.jpg",
        ),
      ),
    ];

    return LeafScaffold(
      appBar: LeafAppBar(data: LeafAppBarData.topic()),
      body: ListView.separated(
        itemBuilder: (context, index) {
          if (index == 0) return topic;
          return LeafTopicArgumentItem(data: argumentData[index - 1]);
        },
        separatorBuilder: (context, index) {
          return const LeafSeparator();
        },
        itemCount: argumentData.length + 1,
      ),
    );
  }
}
