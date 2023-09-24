import 'dart:async';

import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';

class EvidenceUploadScreen extends StatefulWidget {
  final ArgumentRepository argumentRepository;
  final TopicRepository topicRepository;

  const EvidenceUploadScreen({
    super.key,
    required this.argumentRepository,
    required this.topicRepository,
  });

  @override
  State<EvidenceUploadScreen> createState() => _EvidenccUploadScreenState();
}

class _EvidenccUploadScreenState extends State<EvidenceUploadScreen> {
  StreamSubscription? _topicPostLocalSubscription;
  StreamSubscription? _argumentPostLocalSubscription;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _topicPostLocalSubscription = widget.topicRepository.getTopicPosts().listen((posts) async {
      setState(() {
        _isLoading = true;
      });
      for (final post in posts.get().topics) {
        await widget.topicRepository.postTopic(post);
      }
      setState(() {
        _isLoading = false;
      });
    });

    _topicPostLocalSubscription = widget.argumentRepository.getArgumentPosts().listen((posts) async {
      setState(() {
        _isLoading = true;
      });
      for (final post in posts.get().arguments) {
        await widget.argumentRepository.postArgument(post);
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? LinearProgressIndicator() : const SizedBox();
  }

  @override
  void dispose() {
    _topicPostLocalSubscription?.cancel();
    _argumentPostLocalSubscription?.cancel();
    super.dispose();
  }
}
