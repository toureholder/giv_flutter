import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/home/model/quick_menu_item.dart';
import 'package:giv_flutter/util/presentation/rounded_corners.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class HomeQuickMenuSectionTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return Container(
      padding:
          EdgeInsets.fromLTRB(Dimens.default_horizontal_margin, 0.0, 0.0, 0.0),
      child: Subtitle(
        stringFunction('quick_menu_title'),
        weight: SyntheticFontWeight.semiBold,
      ),
    );
  }
}

class HomeQuickMenuOptions extends StatelessWidget {
  final List<QuickMenuItem> items;
  final Function onTap;

  const HomeQuickMenuOptions(
      {Key key, @required this.items, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    final widgetList = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      widgetList.add(QuickMenuOption(
        text: stringFunction(item.text),
        colorList: item.colorList,
        onTap: () {
          this.onTap(item.actionId);
        },
      ));
    }

    widgetList.add(DefaultHorizontalSpacing());

    return Container(
        padding: EdgeInsets.only(top: Dimens.grid(10), bottom: Dimens.grid(16)),
        child: SizedBox(
          height: Dimens.home_product_image_dimension,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: widgetList,
          ),
        ));
  }
}

class QuickMenuOption extends StatelessWidget {
  final String text;
  final List<Color> colorList;
  final GestureTapCallback onTap;

  const QuickMenuOption(
      {Key key,
      @required this.text,
      @required this.colorList,
      @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: Dimens.default_horizontal_margin,
      ),
      child: RoundedCorners(
        child: Container(
          height: Dimens.home_product_image_dimension,
          width: Dimens.home_product_image_dimension,
          decoration: BoxDecoration(color: colorList[0]),
          child: Material(
            color: colorList[0],
            child: InkWell(
              splashColor: colorList[1],
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(Dimens.default_horizontal_margin),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Subtitle(
                      text,
                      weight: SyntheticFontWeight.semiBold,
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
