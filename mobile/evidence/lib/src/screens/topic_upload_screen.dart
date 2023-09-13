import 'dart:async';

import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';

class EvidenceTopicUploadScreen extends StatefulWidget {
  final DebateRepository debateRepository;

  const EvidenceTopicUploadScreen({super.key, required this.debateRepository});

  @override
  State<EvidenceTopicUploadScreen> createState() => _EvidenceTopicUploadScreenState();
}

class _EvidenceTopicUploadScreenState extends State<EvidenceTopicUploadScreen> {
  StreamSubscription? _topicPostLocalSubscription;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _topicPostLocalSubscription = widget.debateRepository.getTopicPosts().listen((posts) async {
      setState(() {
        _isLoading = true;
      });
      for (final post in posts.get().topics) {
        await widget.debateRepository.postTopic(post);
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
    super.dispose();
  }
}
