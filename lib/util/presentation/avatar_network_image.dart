import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AvatarNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const AvatarNetworkImage(
      {Key key, this.imageUrl, this.width = 32.0, this.height = 32.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = (imageUrl != null)
        ? CachedNetworkImage(
            fit: BoxFit.cover,
            width: width,
            height: height,
            imageUrl: imageUrl,
          )
        : SvgPicture.asset(
            'images/pokecoin.svg',
            width: width,
            height: height,
            fit: BoxFit.cover,
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: child,
    );
  }
}
