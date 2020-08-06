import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
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
  final String text;
  final Color textColor;

  const AlertDialogConfirmButton({
    Key key,
    this.text,
    this.textColor,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final finalText = text ?? GetLocalizedStringFunction(context)('common_ok');
    final style = textColor == null ? null : TextStyle(color: textColor);

    return FlatButton(
      child: Text(
        finalText,
        style: style,
      ),
      onPressed: onPressed,
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmationText;
  final Color confirmationTextColor;
  final VoidCallback onConfirmationPressed;

  const CustomAlertDialog({
    Key key,
    this.title,
    this.content,
    this.confirmationText,
    this.confirmationTextColor,
    @required this.onConfirmationPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleWidget = title == null ? null : Text(title);
    final contentWidget = content == null ? null : Text(content);

    return AlertDialog(
      title: titleWidget,
      content: contentWidget,
      actions: <Widget>[
        AlertDialogCancelButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        AlertDialogConfirmButton(
          text: confirmationText,
          textColor: confirmationTextColor,
          onPressed: onConfirmationPressed,
        )
      ],
    );
  }
}

class ProgressIndicatorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 100,
        child: Center(
          child: SharedLoadingState(),
        ),
      ),
    );
  }
}
