import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/features/groups/group_detail/ui/group_detail_hero.dart';
import 'package:giv_flutter/model/image/image.dart' as CustomImage;
import 'package:giv_flutter/util/presentation/rounded_corners.dart';
import 'package:giv_flutter/values/colors.dart';
import 'package:giv_flutter/values/dimens.dart';

class EditGroupImageWidget extends StatelessWidget {
  final CustomImage.Image image;
  final VoidCallback onFabPressed;
  final bool isLoading;

  const EditGroupImageWidget({
    Key key,
    @required this.image,
    @required this.onFabPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stackChildren = <Widget>[
      Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.default_horizontal_margin,
                vertical: 24.0,
              ),
              child: RoundedCorners(
                child: EditGroupImage(image: image),
              ),
            ),
          ),
        ],
      ),
    ];

    final nextWidget = isLoading
        ? Positioned(
            top: 0.0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              color: CustomColors.white75op,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : EditGroupAddImageFab(
            onPressed: onFabPressed,
          );

    stackChildren.add(nextWidget);

    return Stack(
      children: stackChildren,
    );
  }
}

class EditGroupImage extends StatelessWidget {
  const EditGroupImage({
    Key key,
    @required this.image,
  }) : super(key: key);

  final CustomImage.Image image;

  @override
  Widget build(BuildContext context) {
    return image.hasUrl
        ? CachedNetworkImage(
            placeholder: (context, url) => Container(),
            fit: BoxFit.cover,
            height: GroupDetailHero.HEIGHT,
            imageUrl: image.url,
          )
        : Image.file(
            image.file,
            fit: BoxFit.cover,
            height: GroupDetailHero.HEIGHT,
          );
  }
}

class EditGroupAddImageFab extends StatelessWidget {
  final VoidCallback onPressed;

  const EditGroupAddImageFab({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      right: 48.0,
      child: FloatingActionButton(
        onPressed: onPressed,
        child: Icon(Icons.camera_alt),
        elevation: 2.0,
      ),
    );
  }
}
