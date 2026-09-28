import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../app_setting/app_setting.dart';

class CachedImage extends StatefulWidget {
  final String imageUrl;
  final ColorFilter? colorFilter;
  final BoxFit? boxFit;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.colorFilter,
    this.boxFit = BoxFit.contain,
  });

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      imageBuilder: (context, imageProvioder) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: widget.boxFit,
              image: imageProvioder,
              colorFilter: widget.colorFilter,
            ),
          ),
          alignment:
              Alignment.bottomCenter, // This aligns the child of the container
        );
      },
      placeholder:
          (context, url) =>
              Center(child: CircularProgressIndicator(color: colorDisableGrey)),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

// class CachedImageProvider {
//   cachedProvider(String url) async {
//     try {
//       CachedNetworkImageProvider(url);
//     } catch (e) {
//       throw 'Failed to set brightness';
//     }
//   }
// }
