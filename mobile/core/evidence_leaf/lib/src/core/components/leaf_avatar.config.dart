part of 'leaf_avatar.dart';

enum LeafAvatarSize {
  regular,
  small,
  big,
}

class LeafAvatarData {
  final String url;
  const LeafAvatarData({required this.url});
}

extension on LeafAvatarSize {
  Size size(ThemeData theme) {
    switch (this) {
      case LeafAvatarSize.regular:
        return Size.square(theme.spacingScheme.space4);
      case LeafAvatarSize.small:
        return Size.square(theme.spacingScheme.space3);
      case LeafAvatarSize.big:
        return Size.square(theme.spacingScheme.space6);
    }
  }
}
