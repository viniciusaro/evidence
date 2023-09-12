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
        status: LeafTopicArgumentItemStatus.accepted,
        text: "O dinheiro não fará diferença pra quem está dando, mas fará diferença para quem está recebendo",
        avatar: LeafAvatarData(
          url: "https://pbs.twimg.com/profile_images/1262904392698732544/MRyW36Kp_400x400.jpg",
        ),
      ),
      LeafTopicArgumentItemData(
        type: LeafTopicArgumentItemType.against,
        status: LeafTopicArgumentItemStatus.accepted,
        text: "Esta prática incentiva o trabalho infantil, que deve ser erradicado",
        avatar: LeafAvatarData(
          url: "https://pbs.twimg.com/profile_images/1683882159226990606/KRMb92dq_400x400.jpg",
        ),
      ),
      LeafTopicArgumentItemData(
        type: LeafTopicArgumentItemType.against,
        status: LeafTopicArgumentItemStatus.debate,
        text:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
        avatar: LeafAvatarData(
          url:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVvZ2xzLACaO5kX9Y4pk4PSV5YtQyB0FGzXbVymuNSQjZLyoGr9jL0Xgb5AO0oGZSdSzc&usqp=CAU",
        ),
      ),
      LeafTopicArgumentItemData(
        type: LeafTopicArgumentItemType.against,
        status: LeafTopicArgumentItemStatus.rejected,
        text:
            "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.",
        avatar: LeafAvatarData(
          url:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVvZ2xzLACaO5kX9Y4pk4PSV5YtQyB0FGzXbVymuNSQjZLyoGr9jL0Xgb5AO0oGZSdSzc&usqp=CAU",
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
