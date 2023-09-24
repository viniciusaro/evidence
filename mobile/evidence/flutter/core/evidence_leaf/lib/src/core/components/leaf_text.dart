import 'package:evidence_leaf/leaf.dart';

class LeafText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const LeafText(this.data, {super.key, this.style, this.maxLines, this.overflow, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      textAlign: textAlign,
    );
  }
}
