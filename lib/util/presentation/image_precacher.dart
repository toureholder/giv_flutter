import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

void preCacheImages(
  BuildContext context, {
  List<String> assets,
  List<String> urls,
  List<String> svgAssets,
}) {
  if (assets != null && assets.isNotEmpty) {
    for (String assetName in assets) {
      precacheImage(
        AssetImage(assetName),
        context,
      );
    }
  }

  if (urls != null && urls.isNotEmpty) {
    for (String url in urls) {
      precacheImage(
        CachedNetworkImageProvider(url),
        context,
      );
    }
  }

  if (svgAssets != null && svgAssets.isNotEmpty) {
    for (String svgAssetName in svgAssets) {
      precachePicture(
        ExactAssetPicture(
          SvgPicture.svgStringDecoderBuilder,
          svgAssetName,
        ),
        context,
      );
    }
  }
}
