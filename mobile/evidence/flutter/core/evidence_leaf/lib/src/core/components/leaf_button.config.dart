part of 'leaf_button.dart';

enum LeafButtonStyle {
  primary,
  secondary,
}

class LeafButtonData {
  final String title;
  final LeafButtonStyle style;
  const LeafButtonData({required this.title, this.style = LeafButtonStyle.primary});
}
