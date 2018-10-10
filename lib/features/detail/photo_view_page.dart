import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';

class PhotoViewPage extends StatelessWidget {
  final String imageUrl;

  const PhotoViewPage({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.black,
        child: PhotoView(
            minScale: PhotoViewComputedScale.contained * 0.5,
            maxScale: PhotoViewComputedScale.covered * 5.0,
            imageProvider: NetworkImage(imageUrl)
        ),
      ),
    );
  }
}