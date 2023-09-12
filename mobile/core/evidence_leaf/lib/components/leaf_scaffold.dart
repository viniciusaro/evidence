import 'package:evidence_leaf/leaf.dart';

class LeafScaffold extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget? body;
  const LeafScaffold({super.key, required this.appBar, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
