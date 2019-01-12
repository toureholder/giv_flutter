import 'package:flutter/material.dart';

class CustomButton {

  static Widget primary(BuildContext context, { VoidCallback onPressed, String text }) {
    return ButtonTheme(
      height: 48.0,
      minWidth: double.infinity,
      child: FlatButton(
        color: Theme.of(context).accentColor,
        disabledColor: Colors.grey[200],
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: Colors.white),),
      ),
    );
  }
}