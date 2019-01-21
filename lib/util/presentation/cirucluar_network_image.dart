import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircularNetworkImage extends StatelessWidget {
  final String imageUrl;

  const CircularNetworkImage({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        width: 32.0,
        height: 32.0,
        imageUrl: imageUrl,
      ),
    );
  }
}
