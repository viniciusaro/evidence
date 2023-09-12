import 'package:evidence_leaf/leaf.dart';

class EvidenceHomeScreen extends StatelessWidget {
  const EvidenceHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LeafScaffold(
      appBar: LeafAppBar(data: LeafAppBarData.title('🌳')),
      body: ListView(
        children: [
          LeafThreadCard(
            onTap: (context) => Navigator.of(context).pushNamed("topicDetail", arguments: "id"),
            data: const LeafThreadCardData(
              title: "Vini Rodrigues",
              text: "Não se deve dar dinheiro para crianças pedintes na rua.",
              status: LeafThreadCardStatus.debate,
              avatar: LeafAvatarData(
                url: "https://pbs.twimg.com/profile_images/1584303098687885312/SljBjw26_400x400.jpg",
              ),
              arguments: [
                LeafThreadCardArgumentData(
                  type: LeafThreadCardArgumentType.inFavor,
                  text:
                      "O dinheiro não fará diferença pra quem está dando, mas fará diferença para quem está recebendo",
                ),
                LeafThreadCardArgumentData(
                  type: LeafThreadCardArgumentType.against,
                  text: "Esta prática incentiva o trabalho infantil, que deve ser erradicado",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
