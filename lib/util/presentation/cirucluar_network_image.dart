import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircularNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const CircularNetworkImage({Key key, this.imageUrl, this.width = 32.0, this.height = 32.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        width: width,
        height: height,
        imageUrl: imageUrl,
      ),
    );
  }
}
