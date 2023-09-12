import 'package:evidence_leaf/leaf.dart';

enum LeafAvatarSize {
  regular,
  small,
  big,
}

extension on LeafAvatarSize {
  Size size(ThemeData theme) {
    switch (this) {
      case LeafAvatarSize.regular:
        return Size.square(theme.spacingScheme.space4);
      case LeafAvatarSize.small:
        return Size.square(theme.spacingScheme.space2);
      case LeafAvatarSize.big:
        return Size.square(theme.spacingScheme.space6);
    }
  }
}

class LeafAvatarData {
  final String url;
  final LeafAvatarSize size;
  const LeafAvatarData({required this.url, this.size = LeafAvatarSize.regular});
}

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
