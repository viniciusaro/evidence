import 'package:evidence_leaf/leaf.dart';

class LeafScaffold extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget? body;
  final Widget? floatingActionButton;

  const LeafScaffold({
    super.key,
    required this.appBar,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
