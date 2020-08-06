import 'package:flutter/material.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle(this.text, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.default_horizontal_margin),
      child: Subtitle(
        text,
        weight: SyntheticFontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
