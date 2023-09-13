import 'package:evidence_leaf/leaf.dart';
import 'package:iconsax/iconsax.dart';

part 'leaf_app_bar.config.dart';

class LeafAppBar extends StatelessWidget implements PreferredSizeWidget {
  final LeafAppBarData data;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const LeafAppBar({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: data.title,
      leading: data.leading,
      actions: data.actions,
    );
  }
}
