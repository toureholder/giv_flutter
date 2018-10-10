import 'package:flutter/material.dart';

class CustomButton {

  static Widget primary(BuildContext context, { VoidCallback onPressed, String text }) {
    return ButtonTheme(
      height: 48.0,
      child: FlatButton(
        color: Theme.of(context).accentColor,
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: Colors.white),),
      ),
    );
  }
}