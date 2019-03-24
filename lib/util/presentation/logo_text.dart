import 'package:flutter/material.dart';
import 'package:giv_flutter/values/colors.dart';

class LogoText extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _textPart('alguém', Theme.of(context).primaryColor),
        _textPart('quer', CustomColors.logoOrange),
        _textPart('?', Theme.of(context).primaryColor),
      ],
    );
  }

  Text _textPart(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'Overpass', fontSize: 30.0, fontWeight: FontWeight.bold, color: color),
    );
  }
}
