import 'package:evidence_leaf/leaf.dart';

class LeafAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const LeafAppBar({super.key, this.title, this.leading});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: leading,
      backgroundColor: Theme.of(context).colorScheme.background,
      scrolledUnderElevation: 0.7,
    );
  }
}
