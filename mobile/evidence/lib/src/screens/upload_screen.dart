import 'dart:async';

import 'package:evidence_domain/domain.dart';
import 'package:evidence_leaf/leaf.dart';

class EvidenceUploadScreen extends StatefulWidget {
  final DebateRepository debateRepository;

  const EvidenceUploadScreen({super.key, required this.debateRepository});

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

    _topicPostLocalSubscription = widget.debateRepository.getArgumentPosts().listen((posts) async {
      setState(() {
        _isLoading = true;
      });
      for (final post in posts.get().arguments) {
        await widget.debateRepository.postArgument(post);
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
