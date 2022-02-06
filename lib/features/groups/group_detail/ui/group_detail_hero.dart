import 'package:flutter/material.dart';
import 'package:giv_flutter/features/groups/group_detail/ui/group_detail_hero_image.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/util/presentation/gradients.dart';
import 'package:giv_flutter/util/presentation/shadows.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class GroupDetailHero extends StatelessWidget {
  final Group group;
  final GestureTapCallback onTap;
  final Widget actionWidget;

  static const HEIGHT = 128.0;

  const GroupDetailHero({
    Key key,
    @required this.group,
    @required this.onTap,
    this.actionWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = group.imageUrl ?? group.randomImageUrl;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: <Widget>[
          GroupDetailHeroImage(imageUrl: imageUrl),
          GroupDetailHeroOverlay(),
          if (actionWidget != null) GroupDetailHeroEditIconUnderlay(),
          GroupDetailHeroTextAndActions(
            group: group,
            actionWidget: actionWidget,
          ),
        ],
      ),
    );
  }
}

class GroupDetailHeroTextAndActions extends StatelessWidget {
  const GroupDetailHeroTextAndActions(
      {Key key, @required this.group, this.actionWidget})
      : super(key: key);

  final Group group;
  final Widget actionWidget;

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[
      Flexible(
        child: H4Text(
          group.name,
          color: Colors.white,
          weight: SyntheticFontWeight.bold,
          shadows: <Shadow>[
            Shadows.text(),
          ],
        ),
      ),
    ];

    if (actionWidget != null) {
      widgets.add(actionWidget);
    }

    return Positioned(
      bottom: Dimens.default_vertical_margin,
      left: Dimens.default_horizontal_margin,
      right: Dimens.default_horizontal_margin,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widgets,
      ),
    );
  }
}

class GroupDetailHeroOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: GroupDetailHero.HEIGHT,
      decoration: BoxDecoration(
        gradient: Gradients.carouselBottomLeft(),
      ),
    );
  }
}

class GroupDetailHeroEditIconUnderlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: GroupDetailHero.HEIGHT,
      decoration: BoxDecoration(
        gradient: Gradients.carouselBottomRight(),
      ),
    );
  }
}
