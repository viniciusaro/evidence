part of 'leaf_image.dart';

sealed class LeafImageData {
  const LeafImageData._();
  factory LeafImageData.network({required String url}) = _LeafImageDataNetwork;
}

class _LeafImageDataNetwork extends LeafImageData {
  final String url;
  const _LeafImageDataNetwork({required this.url}) : super._();
}
