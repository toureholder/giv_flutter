import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/model/image/image.dart' as CustomImage;
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatelessWidget {
  final CustomImage.Image image;
  final List<Widget> actions;

  const PhotoViewPage({Key key, @required this.image, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageProvider = image.hasUrl
        ? CachedNetworkImageProvider(image.url)
        : FileImage(image.file);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: actions,
      ),
      body: Container(
        color: Colors.black,
        child: PhotoView(
            minScale: PhotoViewComputedScale.contained * 1,
            maxScale: PhotoViewComputedScale.covered * 5.0,
            imageProvider: imageProvider),
      ),
    );
  }
}
