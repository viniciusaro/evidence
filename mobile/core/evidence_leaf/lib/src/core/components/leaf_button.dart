import 'package:evidence_leaf/leaf.dart';

part 'leaf_button.config.dart';

class LeafButton extends StatelessWidget {
  final LeafButtonData data;
  final InteractionCallback onPressed;

  const LeafButton({super.key, required this.data, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    switch (data.style) {
      case LeafButtonStyle.primary:
        return OutlinedButton(
          onPressed: () => onPressed(context),
          child: LeafText(data.title),
        );
      case LeafButtonStyle.secondary:
        return FilledButton(
          onPressed: () => onPressed(context),
          child: LeafText(data.title),
        );
    }
  }
}
