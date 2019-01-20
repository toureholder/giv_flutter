import 'package:flutter/material.dart';
import 'package:giv_flutter/values/custom_icons_icons.dart';
import 'package:giv_flutter/values/dimens.dart';

class MainButtonTheme extends StatelessWidget {
  final Widget child;

  const MainButtonTheme({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: Dimens.button_flat_height,
      minWidth: double.infinity,
      child: child,
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const PrimaryButton({Key key, this.onPressed, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainButtonTheme(
      child: FlatButton(
        color: Theme.of(context).accentColor,
        textColor: Colors.white,
        disabledColor: Colors.grey[200],
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Icon icon;
  final Color color;

  const CustomIconButton(
      {Key key, this.onPressed, this.text, this.icon, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainButtonTheme(
      child: FlatButton(
        color: color,
        textColor: Colors.white,
        disabledColor: Colors.grey[200],
        onPressed: onPressed,
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(text),
              ],
            ),
            Positioned(left: 10.0, child: icon)
          ],
        ),
      ),
    );
  }
}

class WhiteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const WhiteButton({Key key, this.onPressed, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainButtonTheme(
      child: FlatButton(
        color: Colors.white,
        textColor: Colors.black,
        disabledColor: Colors.grey[200],
        disabledTextColor: Colors.white,
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

class GreyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const GreyButton({Key key, this.onPressed, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainButtonTheme(
      child: FlatButton(
        color: Colors.grey[300],
        textColor: Colors.black,
        disabledTextColor: Colors.grey[200],
        onPressed: onPressed,
        child: Text(text),
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
        color: Colors.grey[300],
        onPressed: onPressed,
        icon: icon,
        label: label);
  }
}

class FacebookButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const FacebookButton({Key key, this.onPressed, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      color: Color(0xFF3B5998),
      onPressed: onPressed,
      icon: Icon(
        CustomIcons.facebook,
        size: 18.0,
      ),
      text: text,
    );
  }
}

class SmallFlatPrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const SmallFlatPrimaryButton({Key key, this.onPressed, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Text(
        text,
        style:
            TextStyle(fontSize: 14.0, letterSpacing: 0.1, color: Colors.blue),
      ),
    );
  }
}

class MediumFlatPrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const MediumFlatPrimaryButton({Key key, this.onPressed, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 15.0,
            letterSpacing: 0.1,
            color: Colors.blue,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
