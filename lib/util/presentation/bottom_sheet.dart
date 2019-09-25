import 'package:flutter/material.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class CustomBottomSheet {
  static show(BuildContext context,
      {List<Widget> tiles, String title}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          final List<Widget> children = [];

          if (title != null && title.isNotEmpty)
            children.addAll(_titleComponent(title));

          children.addAll(tiles);
          children.add(Spacing.vertical(Dimens.default_vertical_margin));

          return BottomSheetColumn(children: children);
        });
  }

  static List<Widget> _titleComponent(String title) {
    return [
      Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(Dimens.default_horizontal_margin),
            child: Subtitle(
              title,
              weight: SyntheticFontWeight.bold,
            ),
          ),
        ],
      ),
      Spacing.vertical(Dimens.grid(2))
    ];
  }
}

class BottomSheetTile extends StatelessWidget {
  final IconData iconData;
  final String text;
  final GestureTapCallback onTap;

  const BottomSheetTile({Key key, this.iconData, this.text, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(text),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}

class BottomSheetColumn extends StatelessWidget {
  final List<Widget> children;

  const BottomSheetColumn({Key key, @required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: children,
    );
  }
}
