import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
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

  void onLoginSuccess(Widget redirect) {
    if (redirect == null) {
      Navigation(context).push(Base(), clearStack: true);
    } else {
      Navigation(context).pushReplacement(redirect);
    }
  }

  void showGenericErrorDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(string('error_generic_title')),
            content: Text(string('error_generic_message')),
            actions: <Widget>[
              FlatButton(
                  child: Text(string('action_report')),
                  onPressed: () {
                    Util.customerService(
                        string('error_generic_report_message'));
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
}
