import 'dart:async';

import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';

class EvidenceTopicDetailScreen extends StatefulWidget {
  final EvidenceTopicId topicId;
  final TopicRepository topicRepository;

  const EvidenceTopicDetailScreen({
    super.key,
    required this.topicId,
    required this.topicRepository,
  });

  @override
  State<EvidenceTopicDetailScreen> createState() => _EvidenceTopicDetailScreenState();
}

class _EvidenceTopicDetailScreenState extends State<EvidenceTopicDetailScreen> {
  EvidenceTopic? _topic;
  StreamSubscription? _topicSubscription;

  @override
  void initState() {
    super.initState();
    _topicSubscription = widget.topicRepository.getTopic(widget.topicId).listen((result) {
      setState(() {
        _topic = result.get();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final topic = _topic;
    if (topic != null) {
      return _buildWithTopic(topic);
    }
    return Container(color: Colors.white);
  }

  Widget _buildWithTopic(EvidenceTopic topic) {
    final topicItem = LeafTopicItem(
      data: LeafTopicItemData(
        title: topic.publisher.name,
        text: topic.declaration,
        status: topic.status,
        likeCount: topic.likeCount,
        avatar: LeafAvatarData(url: topic.publisher.profilePictureUrl),
      ),
      onLikeTap: (_) async {
        await widget.topicRepository.likeTopic(topic);
      },
      onSupportTap: (_) {
        Navigator.of(context).pushNamed(
          EvidenceRoutes.inFavorArgumentCompositionModal.routeName,
          arguments: _topic,
        );
      },
      onContestTap: (_) {
        Navigator.of(context).pushNamed(
          EvidenceRoutes.againstArgumentCompositionModal.routeName,
          arguments: _topic,
        );
      },
    );

    final argumentData = topic.arguments.map((argument) {
      return LeafTopicArgumentItemData(
        type: argument.type,
        status: argument.topic.status,
        likeCount: argument.topic.likeCount,
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
                arguments: topic.arguments[index - 1].topic.id,
              );
            },
            onLongPress: (context) {
              //
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

  @override
  void dispose() {
    _topicSubscription?.cancel();
    super.dispose();
  }
}
