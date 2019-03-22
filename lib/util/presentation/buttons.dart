import 'package:flutter/material.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/custom_icons_icons.dart';
import 'package:giv_flutter/values/dimens.dart';

class MainButtonTheme extends StatelessWidget {
  final Widget child;
  final bool fillWidth;

  const MainButtonTheme({Key key, this.child, this.fillWidth = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var minWidth = fillWidth ? double.maxFinite : 88.0;

    return ButtonTheme(
      height: Dimens.button_flat_height,
      minWidth: minWidth,
      child: child,
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final bool fillWidth;

  const PrimaryButton(
      {Key key, this.onPressed, this.text, this.isLoading = false, this.fillWidth = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = isLoading ? ButtonProgressIndicator() : Text(text);
    final finalOnPressed = isLoading ? null : onPressed;

    return MainButtonTheme(
      child: FlatButton(
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        disabledColor:
            isLoading ? Theme.of(context).accentColor : Colors.grey[200],
        disabledTextColor: Colors.white,
        onPressed: finalOnPressed,
        child: child,
      ),
      fillWidth: fillWidth,
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Icon icon;
  final Color color;
  final bool isLoading;

  const CustomIconButton(
      {Key key,
      this.onPressed,
      this.text,
      this.icon,
      this.color,
      this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? ButtonProgressIndicator()
        : Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(text),
                ],
              ),
              Positioned(left: 10.0, child: icon)
            ],
          );

    final finalOnPressed = isLoading ? null : onPressed;

    return MainButtonTheme(
      child: FlatButton(
        color: color,
        textColor: Colors.white,
        disabledColor: isLoading ? color : Colors.grey[200],
        disabledTextColor: Colors.white,
        onPressed: finalOnPressed,
        child: child,
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
  final bool fillWidth;

  const GreyButton({Key key, this.onPressed, this.text, this.fillWidth = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainButtonTheme(
      fillWidth: fillWidth,
      child: FlatButton(
        color: Colors.grey[300],
        textColor: Colors.black,
        disabledColor: Colors.grey[200],
        disabledTextColor: Colors.white,
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
  final bool isLoading;

  const FacebookButton(
      {Key key, this.onPressed, this.text, this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      color: Color(0xFF3B5998),
      onPressed: onPressed,
      icon: Icon(
        CustomIcons.facebook_1,
        size: 18.0,
      ),
      text: text,
      isLoading: isLoading,
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

class MediumFlatDangerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const MediumFlatDangerButton({Key key, this.onPressed, this.text})
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
            color: Colors.red,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class TextFlatButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const TextFlatButton({Key key, this.onPressed, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: CustomTypography.body2,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ButtonProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26.0,
      height: 26.0,
      child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
    );
  }
}
