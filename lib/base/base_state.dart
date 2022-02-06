import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/features/customer_service/bloc/customer_service_dialog_bloc.dart';
import 'package:giv_flutter/features/customer_service/ui/customer_service_dialog.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/service/preferences/shared_preferences_storage.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseState<T extends StatefulWidget> extends State<T> {
  Navigation navigation;
  GetLocalizedStringFunction string;
  String localeString;
  Util util;

  @override
  Widget build(BuildContext context) {
    util = Provider.of<Util>(context, listen: false);
    navigation = Navigation(context);
    string = GetLocalizedStringFunction(context);
    localeString = util.getCurrentLocaleString(context);
    return null;
  }

  void onLoginResponse(HttpResponse response, Widget redirect) {
    switch (response.status) {
      case HttpStatus.ok:
        _onLoginSuccess(redirect);
        break;
      case HttpStatus.unprocessableEntity:
        showInformationDialog(
            title: string('log_in_error_bad_credentials_title'),
            content: string('log_in_error_bad_credentials_message'));
        break;
      case HttpStatus.notAcceptable:
        showInformationDialog(
            title: string('log_in_error_not_activated_title'),
            content: string('log_in_error_not_activated_message'));
        break;
      default:
        showGenericErrorDialog();
    }
  }

  void _onLoginSuccess(Widget redirect) {
    if (redirect == null) {
      navigation.push(Base(), clearStack: true);
    } else {
      navigation.pushReplacement(redirect);
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
          return GenericErrorDialog(
            message: message,
            content: content,
            util: util,
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
              TextButton(
                  child: Text(string('common_ok')),
                  onPressed: () {
                    Navigation(context).pop();
                  })
            ],
          );
        });
  }

  void handleCustomerServiceRequest(String message) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final storage = SharedPreferencesStorage(sharedPreferences);

    final hasAgreed = storage.hasAgreedToCustomerService();

    if (hasAgreed)
      util.launchCustomerService(message);
    else
      showCustomerServiceDialog(message);
  }

  void showCustomerServiceDialog(String message) {
    message = message ?? string('help_message');

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Consumer<CustomerServiceDialogBloc>(
            builder: (context, bloc, child) => CustomerServiceDialog(
              bloc: bloc,
              message: message,
            ),
          );
        });
  }
}

class GenericErrorDialog extends StatelessWidget {
  final String content;
  final String message;
  final Util util;

  const GenericErrorDialog({
    Key key,
    @required this.content,
    @required this.message,
    @required this.util,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final string = GetLocalizedStringFunction(context);
    return AlertDialog(
      title: Text(string('error_generic_title')),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          child: Text(string('action_report')),
          onPressed: () {
            util.launchCustomerService(message);
            Navigation(context).pop();
          },
        ),
        TextButton(
          child: Text(string('common_ok')),
          onPressed: () {
            Navigation(context).pop();
          },
        ),
      ],
    );
  }
}
