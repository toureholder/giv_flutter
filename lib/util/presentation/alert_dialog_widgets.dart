import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/presentation/typography.dart';

class AlertDialogTitle extends StatelessWidget {
  final String text;

  const AlertDialogTitle({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: Text(text),
    );
  }
}

class AlertDialogContent extends StatelessWidget {
  final String text;

  const AlertDialogContent({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
      child: Text(text),
    );
  }
}

class AlertDialogCheckBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AlertDialogCheckBox({
    Key key,
    @required this.value,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, top: 8.0),
      child: Checkbox(value: value, onChanged: onChanged),
    );
  }
}

class AlertDialogCheckBoxText extends StatelessWidget {
  final String text;

  const AlertDialogCheckBoxText({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: BodyText(text),
    );
  }
}

class AlertDialogCancelButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AlertDialogCancelButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(GetLocalizedStringFunction(context)('shared_action_cancel')),
      onPressed: onPressed,
    );
  }
}

class AlertDialogConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AlertDialogConfirmButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(GetLocalizedStringFunction(context)('common_ok')),
      onPressed: onPressed,
    );
  }
}
