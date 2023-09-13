import 'package:evidence_leaf/leaf.dart';

class LeafTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;

  const LeafTextField({super.key, this.hintText, this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: theme.spacingScheme.margin,
      child: TextField(
        controller: controller,
        autofocus: true,
        style: theme.textTheme.headlineSmall,
        decoration: InputDecoration.collapsed(
          hintText: hintText,
          hintStyle: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary.withAlpha(120)),
        ),
      ),
    );
  }
}
