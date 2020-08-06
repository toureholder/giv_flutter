import 'package:flutter/material.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class MyGroupsSubTitle extends StatelessWidget {
  const MyGroupsSubTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimens.default_horizontal_margin,
        right: Dimens.default_horizontal_margin,
        bottom: Dimens.default_horizontal_margin,
      ),
      child: Subtitle(
        'Grupos',
        weight: SyntheticFontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
