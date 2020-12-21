import 'package:flutter/material.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/colors.dart';
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
      {Key key,
      this.onPressed,
      this.text,
      this.isLoading = false,
      this.fillWidth = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? ButtonProgressIndicator(
            color: CustomColors.primaryColorText,
          )
        : Text(text);
    final finalOnPressed = isLoading ? null : onPressed;

    return MainButtonTheme(
      child: FlatButton(
        color: Theme.of(context).primaryColor,
        textColor: CustomColors.primaryColorText,
        disabledColor:
            isLoading ? Theme.of(context).primaryColor : Colors.grey[200],
        disabledTextColor: CustomColors.primaryColorText,
        onPressed: finalOnPressed,
        child: child,
      ),
      fillWidth: fillWidth,
    );
  }
}

class AccentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final bool fillWidth;

  const AccentButton(
      {Key key,
      this.onPressed,
      this.text,
      this.isLoading = false,
      this.fillWidth = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? ButtonProgressIndicator(
            color: CustomColors.accentColorText,
          )
        : Text(text);
    final finalOnPressed = isLoading ? null : onPressed;

    return MainButtonTheme(
      child: FlatButton(
        color: Theme.of(context).accentColor,
        textColor: CustomColors.accentColorText,
        disabledColor:
            isLoading ? Theme.of(context).accentColor : Colors.grey[200],
        disabledTextColor: Colors.black,
        onPressed: finalOnPressed,
        child: child,
      ),
      fillWidth: fillWidth,
    );
  }
}

class DangerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final bool fillWidth;

  const DangerButton({
    Key key,
    this.onPressed,
    this.text,
    this.isLoading = false,
    this.fillWidth = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? ButtonProgressIndicator(
            color: CustomColors.primaryColorText,
          )
        : Text(text);
    final finalOnPressed = isLoading ? null : onPressed;

    return MainButtonTheme(
      child: FlatButton(
        color: CustomColors.dangerColor,
        textColor: CustomColors.primaryColorText,
        disabledColor: isLoading ? CustomColors.dangerColor : Colors.grey[200],
        disabledTextColor: CustomColors.primaryColorText,
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
  final Color backgroundColor;
  final bool isLoading;
  final Color textColor;

  const CustomIconButton({
    Key key,
    @required this.onPressed,
    @required this.text,
    @required this.icon,
    @required this.backgroundColor,
    @required this.textColor,
    @required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? ButtonProgressIndicator(
            color: textColor,
          )
        : Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(text),
                ],
              ),
              Positioned(left: 4.0, child: icon)
            ],
          );

    final finalOnPressed = isLoading ? null : onPressed;

    return MainButtonTheme(
      child: FlatButton(
        color: backgroundColor,
        textColor: Colors.white,
        disabledColor: isLoading ? backgroundColor : Colors.grey[200],
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
  final IconData iconData;

  const GreyIconButton({
    Key key,
    this.onPressed,
    this.text,
    this.isFlexible = false,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textWidget = Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    var label = isFlexible ? Flexible(child: textWidget) : textWidget;

    return MainButtonTheme(
      child: FlatButton.icon(
          color: Colors.grey[300],
          onPressed: onPressed,
          icon: Icon(iconData, color: Colors.grey),
          label: label),
    );
  }
}

class GreyOutlineButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool fillWidth;

  const GreyOutlineButton(
      {Key key, this.onPressed, this.text, this.fillWidth = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainButtonTheme(
      fillWidth: fillWidth,
      child: OutlineButton(
        borderSide: BorderSide(
          color: Colors.grey[300],
          style: BorderStyle.solid,
          width: 0.8,
        ),
        color: Colors.grey[300],
        textColor: Colors.black,
        disabledBorderColor: Colors.grey[200],
        disabledTextColor: Colors.white,
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

class GreyOutlineIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isFlexible;
  final IconData iconData;

  const GreyOutlineIconButton({
    Key key,
    this.onPressed,
    this.text,
    this.isFlexible = false,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textWidget = Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    var label = isFlexible ? Flexible(child: textWidget) : textWidget;

    return MainButtonTheme(
      child: OutlineButton.icon(
          borderSide: BorderSide(
            color: Colors.grey[300],
            style: BorderStyle.solid,
            width: 0.8,
          ),
          textColor: Colors.black,
          onPressed: onPressed,
          icon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(iconData, color: Colors.black),
          ),
          label: label),
    );
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
      backgroundColor: Color(0xFF3B5998),
      textColor: Colors.white,
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
    final color = onPressed == null ? Colors.grey : Colors.blue;

    return FlatButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 15.0,
            letterSpacing: 0.1,
            color: color,
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

  const TextFlatButton({Key key, this.onPressed, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: CustomTypography.body2.copyWith(
          color: CustomColors.textLinkColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ButtonProgressIndicator extends StatelessWidget {
  final Color color;

  const ButtonProgressIndicator({
    Key key,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26.0,
      height: 26.0,
      child: CircularProgressIndicator(
          strokeWidth: 3.0, valueColor: AlwaysStoppedAnimation<Color>(color)),
    );
  }
}
