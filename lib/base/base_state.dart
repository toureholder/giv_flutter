import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/util.dart';

class BaseState<T extends StatefulWidget> extends State<T> {
  Navigation navigation;
  GetLocalizedStringFunction string;
  String localeString;

  @override
  Widget build(BuildContext context) {
    navigation = Navigation(context);
    string = GetLocalizedStringFunction(context);
    localeString = Util.getCurrentLocaleString(context);
    return null;
  }

  void onLoginResponse(HttpResponse response, Widget redirect) {
    switch(response.status) {
      case HttpStatus.ok:
        _onLoginSuccess(redirect);
        break;
      case HttpStatus.unprocessableEntity:
        showInformationDialog(
            title: string('log_in_error_bad_credentials_title'),
            content: string('log_in_error_bad_credentials_message')
        );
        break;
      case HttpStatus.notAcceptable:
        showInformationDialog(
            title: string('log_in_error_not_activated_title'),
            content: string('log_in_error_not_activated_message')
        );
        break;
      default:
        showGenericErrorDialog();
    }
  }

  void _onLoginSuccess(Widget redirect) {
    if (redirect == null) {
      Navigation(context).push(Base(), clearStack: true);
    } else {
      Navigation(context).pushReplacement(redirect);
    }
  }

  void onUpdateUserResponse(HttpResponse<User> response) {
    if (response.status == HttpStatus.ok) {
      _onUpdateUserSuccess(response.data);
      return;
    }

    showGenericErrorDialog();
  }

  void _onUpdateUserSuccess(User user) {
    Navigator.pop(context, user);
  }

  void showGenericErrorDialog({String message, String content}) {
    message = message ?? string('error_generic_report_message');
    content = content ?? string('error_generic_message');

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(string('error_generic_title')),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                  child: Text(string('action_report')),
                  onPressed: () {
                    Util.customerService(message);
                    Navigation(context).pop();
                  }),
              FlatButton(
                  child: Text(string('common_ok')),
                  onPressed: () {
                    Navigation(context).pop();
                  })
            ],
          );
        });
  }

  void showInformationDialog({String title, String content}) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: title == null ? null : Text(title),
            content: content == null ? null : Text(content),
            actions: <Widget>[
              FlatButton(
                  child: Text(string('common_ok')),
                  onPressed: () {
                    Navigation(context).pop();
                  })
            ],
          );
        });
  }
}
