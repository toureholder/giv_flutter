import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:giv_flutter/model/image/image.dart' as CustomImage;
import 'package:giv_flutter/values/colors.dart';

class AvatarImage extends StatelessWidget {
  final CustomImage.Image image;
  final double width;
  final double height;
  final bool isLoading;

  const AvatarImage(
      {Key key,
      this.image,
      this.width = 32.0,
      this.height = 32.0,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[
      AvatarPlaceHolder(width: width, height: height),
    ];

    if (image != null && !image.isEmpty) {
      final avatar = (image.hasUrl)
          ? CachedNetworkImage(
              fit: BoxFit.cover,
              width: width,
              height: height,
              imageUrl: image.url,
            )
          : Image.file(image.file,
              fit: BoxFit.cover, width: width, height: height);

      widgets.add(avatar);
    }

    if (isLoading)
      widgets.addAll([
        Container(
          width: width,
          height: height,
          color: CustomColors.white75op,
        ),
        SizedBox(
          width: width,
          height: height,
          child: CircularProgressIndicator(
            strokeWidth: 5.0,
          ),
        )
      ]);

    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Stack(children: widgets),
    );
  }
}

class AvatarPlaceHolder extends StatelessWidget {
  final double width;
  final double height;

  const AvatarPlaceHolder({Key key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'images/user_bw.svg',
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
