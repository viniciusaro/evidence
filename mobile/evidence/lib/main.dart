import 'package:evidence_leaf/leaf.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LeafScaffold(
      appBar: const LeafAppBar(title: LeafText('🌳')),
      body: ListView(
        children: const [
          LeafThreadCard(
            data: LeafThreadCardData(
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
