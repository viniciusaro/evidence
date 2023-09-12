import 'package:evidence_leaf/leaf.dart';

class EvidenceTopicDetailScreen extends StatelessWidget {
  final String id;

  const EvidenceTopicDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return LeafScaffold(
      appBar: LeafAppBar(data: LeafAppBarData.topic()),
      body: const SizedBox(),
    );
  }
}
