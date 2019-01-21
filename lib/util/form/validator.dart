import 'package:flutter/widgets.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';

class Validator {
  BuildContext context;
  GetLocalizedStringFunction string;

  Validator(BuildContext context) {
    this.context = context;
    string = GetLocalizedStringFunction(context);
  }

  String userName(String value) {
    String message;
    if (value.isEmpty) message = string('validation_message_name_required');
    return message;
  }

  String email(String value) {
    String message;

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value))
      message = string('validation_message_email_required');

    return message;
  }

  String password(String value) {
    String message;
    if (value.length < 6)
      message = string('validation_message_password_min_length');
    return message;
  }

  String required(String value) {
    String message;
    if (value.isEmpty) message = string('validation_message_required');
    return message;
  }
}
