import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const PrimaryButton({Key key, this.onPressed, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 48.0,
      minWidth: double.infinity,
      child: FlatButton(
        color: Theme.of(context).accentColor,
        disabledColor: Colors.grey[200],
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class GreyIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isFlexible;
  final Icon icon;

  const GreyIconButton(
      {Key key, this.onPressed, this.text, this.isFlexible = false, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textWidget = Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    var label = isFlexible ? Flexible(child: textWidget) : textWidget;

    return FlatButton.icon(
        color: Colors.grey[200],
        onPressed: onPressed,
        icon: icon,
        label: label);
  }
}

class SmallFlatPrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const SmallFlatPrimaryButton({Key key, this.onPressed, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 14.0, letterSpacing: 0.1, color: Colors.blue),
      ),
    );
  }
}

