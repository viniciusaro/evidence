import 'package:cached_network_image/cached_network_image.dart';
import 'package:evidence_leaf/leaf.dart';

part 'leaf_image.config.dart';

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
