import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';

class EvidenceTopicCompositionScreen extends StatefulWidget {
  final TopicRepository topicRepository;

  const EvidenceTopicCompositionScreen({
    super.key,
    required this.topicRepository,
  });

  @override
  State<EvidenceTopicCompositionScreen> createState() => _EvidenceTopicCompositionScreenState();
}

class _EvidenceTopicCompositionScreenState extends State<EvidenceTopicCompositionScreen> {
  final inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LeafScaffold(
      appBar: LeafAppBar(
        data: LeafAppBarData.compose().copyWith(actions: [
          LeafAppBarData.composeSendAction(
            onPressed: () async {
              final topic = EvidenceTopicPost(declaration: inputController.text);
              await widget.topicRepository.registerTopicPost(topic);
              Navigator.of(context).pop();
            },
          ),
        ]),
      ),
      body: ListView(
        children: [
          LeafTextField(
            hintText: "O que você gostaria de debater?",
            controller: inputController,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }
}
