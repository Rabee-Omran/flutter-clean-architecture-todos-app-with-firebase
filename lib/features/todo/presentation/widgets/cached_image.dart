import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  const CachedImage({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
      placeholder: (context, url) => Transform.scale(
        scale: 0.5,
        child: Container(width: 100.0, height: 100.0, child: LoadingWidget()),
      ),
      errorWidget: (context, url, error) => Transform.scale(
        scale: 0.5,
        child: Container(width: 100.0, height: 100.0, child: LoadingWidget()),
      ),
    );
  }
}
