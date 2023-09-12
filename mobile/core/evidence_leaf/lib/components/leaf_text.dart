import 'package:evidence_leaf/leaf.dart';

part 'leaf_text.config.dart';

class LeafText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  const LeafText(this.data, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style,
    );
  }
}
