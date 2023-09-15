import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';

class EvidenceArgumentCompositionScreen extends StatefulWidget {
  final EvidenceTopic topic;
  final EvidenceArgumentType type;
  final DebateRepository debateRepository;

  const EvidenceArgumentCompositionScreen({
    super.key,
    required this.topic,
    required this.type,
    required this.debateRepository,
  });

  @override
  State<EvidenceArgumentCompositionScreen> createState() => _EvidenceArgumentCompositionScreenState();
}

class _EvidenceArgumentCompositionScreenState extends State<EvidenceArgumentCompositionScreen> {
  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final side = widget.type == EvidenceArgumentType.inFavor ? "a favor" : "contra";

    return LeafScaffold(
      appBar: LeafAppBar(
        data: LeafAppBarData.compose().copyWith(actions: [
          LeafAppBarData.composeSendAction(
            onPressed: () async {
              final argument = EvidenceArgumentPost(
                aboutTopic: widget.topic,
                type: widget.type,
                declaration: inputController.text,
              );
              await widget.debateRepository.registerArgumentPost(argument);
              Navigator.of(context).pop();
            },
          ),
        ]),
      ),
      body: ListView(
        children: [
          LeafTopicItem(
            data: LeafTopicItemData(
              title: widget.topic.publisher.name,
              text: widget.topic.declaration,
              likeCount: widget.topic.likeCount,
              avatar: LeafAvatarData(url: widget.topic.publisher.profilePictureUrl),
              status: widget.topic.status,
            ),
            showActionButtons: false,
          ),
          LeafTextField(
            hintText: "Exponha seus argumentos $side o tópico",
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
