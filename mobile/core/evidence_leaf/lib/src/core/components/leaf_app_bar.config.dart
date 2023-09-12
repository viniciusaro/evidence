part of 'leaf_app_bar.dart';

class LeafAppBarData {
  final Widget? title;
  final Widget? leading;
  const LeafAppBarData({this.title, this.leading});

  factory LeafAppBarData.title(String title) {
    return LeafAppBarData(title: LeafText(title));
  }

  factory LeafAppBarData.topic() {
    return const LeafAppBarData(title: Icon(Iconsax.messages_35));
  }
}
