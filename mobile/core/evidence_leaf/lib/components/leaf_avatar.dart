import 'package:evidence_leaf/leaf.dart';

part 'leaf_avatar.config.dart';

class LeafAvatar extends StatelessWidget {
  final LeafAvatarData data;
  const LeafAvatar({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: data.size.size(theme).width,
      height: data.size.size(theme).height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(theme.spacingScheme.radiusCircular),
        border: Border.all(color: theme.colorScheme.primary, width: 2),
      ),
      child: ClipOval(child: LeafImage(data: LeafImageData.network(url: data.url))),
    );
  }
}
