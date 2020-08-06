import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/features/groups/group_detail/ui/group_detail_hero.dart';
import 'package:giv_flutter/values/colors.dart';

class GroupDetailHeroImage extends StatelessWidget {
  final String imageUrl;

  const GroupDetailHeroImage({
    Key key,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageUrl == null
        ? GroupDetailHeroImagePlaceHolder()
        : Row(
            children: <Widget>[
              Expanded(
                child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      GroupDetailHeroImagePlaceHolder(),
                  fit: BoxFit.cover,
                  height: GroupDetailHero.HEIGHT,
                  imageUrl: imageUrl,
                ),
              ),
            ],
          );
  }
}

class GroupDetailHeroImagePlaceHolder extends StatelessWidget {
  const GroupDetailHeroImagePlaceHolder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: GroupDetailHero.HEIGHT,
      decoration: BoxDecoration(
        color: CustomColors.random(),
      ),
    );
  }
}
