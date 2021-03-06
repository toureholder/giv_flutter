import 'package:flutter/material.dart';
import 'package:giv_flutter/values/colors.dart';

class LogoText extends StatelessWidget {
  final double fontSize;

  const LogoText({Key key, this.fontSize = 30.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _textPart('alguém', Theme.of(context).primaryColor),
        _textPart('quer', CustomColors.accentColor),
        _textPart('?', Theme.of(context).primaryColor),
      ],
    );
  }

  Text _textPart(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Overpass',
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
