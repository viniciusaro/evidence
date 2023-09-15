import 'dart:async';
import 'dart:math';

import 'package:evidence/src/screens/upload_screen.dart';
import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';

class EvidenceHomeScreen extends StatefulWidget {
  final DebateRepository debateRepository;

  const EvidenceHomeScreen({super.key, required this.debateRepository});

  @override
  State<EvidenceHomeScreen> createState() => _EvidenceHomeScreenState();
}

class _EvidenceHomeScreenState extends State<EvidenceHomeScreen> {
  List<EvidenceTopic> _topics = [];
  StreamSubscription? _topicsSubscription;

  @override
  void initState() {
    super.initState();
    _topicsSubscription = widget.debateRepository.getTopics().listen((result) {
      setState(() {
        _topics = result.get().topics;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = _topics.map((topic) {
      final arguments = topic.arguments.getRange(0, max(0, min(2, topic.arguments.length))).map(
            (argument) => LeafTopicItemArgumentData(
              text: argument.topic.declaration,
              type: argument.type,
            ),
          );

      return LeafTopicItem(
        onTap: (context) => Navigator.of(context).pushNamed(EvidenceRoutes.topicDetail.routeName, arguments: topic.id),
        maxLines: 5,
        showActionButtons: false,
        data: LeafTopicItemData(
          title: topic.publisher.name,
          text: topic.declaration,
          status: topic.status,
          likeCount: topic.likeCount,
          avatar: LeafAvatarData(url: topic.publisher.profilePictureUrl),
          arguments: arguments.toList(),
        ),
      );
    }).toList();

    final body = ListView.separated(
      itemBuilder: (context, index) {
        return items[index];
      },
      separatorBuilder: (context, index) {
        return const LeafSeparator();
      },
      itemCount: items.length,
    );

    return LeafScaffold(
      appBar: LeafAppBar(data: LeafAppBarData.title('🌳')),
      body: Stack(
        children: [
          body,
          EvidenceUploadScreen(debateRepository: widget.debateRepository),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: LeafText(" ➕", textAlign: TextAlign.center),
        onPressed: () {
          Navigator.of(context).pushNamed(EvidenceRoutes.topicCompositionModal.routeName);
        },
      ),
    );
  }

  @override
  void dispose() {
    _topicsSubscription?.cancel();
    super.dispose();
  }
}
