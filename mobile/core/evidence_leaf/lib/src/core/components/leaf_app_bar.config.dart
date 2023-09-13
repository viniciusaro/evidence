part of 'leaf_app_bar.dart';

class LeafAppBarData {
  final Widget? title;
  final Widget? leading;
  final List<Widget> actions;

  const LeafAppBarData({this.title, this.leading, this.actions = const []});

  factory LeafAppBarData.title(String title) {
    return LeafAppBarData(title: LeafText(title));
  }

  factory LeafAppBarData.topic() {
    return const LeafAppBarData(title: Icon(Iconsax.messages_35));
  }

  factory LeafAppBarData.compose() {
    return const LeafAppBarData(title: Icon(Iconsax.additem5));
  }

  static Widget composeSendAction({required void Function() onPressed}) {
    return IconButton(onPressed: onPressed, icon: Icon(Iconsax.send_15));
  }

  LeafAppBarData copyWith({List<Widget>? actions}) {
    return LeafAppBarData(
      title: title,
      leading: leading,
      actions: actions ?? this.actions,
    );
  }
}
