import 'package:cached_network_image/cached_network_image.dart';

import 'package:evidence_leaf/leaf.dart';

sealed class LeafImageData {
  const LeafImageData._();
  factory LeafImageData.network({required String url}) = _LeafImageDataNetwork;
}

class _LeafImageDataNetwork extends LeafImageData {
  final String url;
  const _LeafImageDataNetwork({required this.url}) : super._();
}

class LeafImage extends StatelessWidget {
  final LeafImageData data;

  const LeafImage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (data) {
      case _LeafImageDataNetwork data:
        return CachedNetworkImage(imageUrl: data.url);
    }
  }
}
