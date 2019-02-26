import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/util/util.dart';

class CustomerServiceDialog extends StatefulWidget {
  final String message;

  const CustomerServiceDialog({Key key, this.message}) : super(key: key);

  @override
  _CustomerServiceDialogState createState() => _CustomerServiceDialogState();
}

class _CustomerServiceDialogState extends BaseState<CustomerServiceDialog> {
  bool showNoMore = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
      title: _title(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _content(),
          Row(
            children: <Widget>[_checkbox(), _checkboxText()],
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
            child: Text(string('shared_action_cancel')),
            onPressed: () {
              Navigation(context).pop();
            }),
        FlatButton(
            child: Text(string('common_ok')),
            onPressed: () async {
              if (showNoMore) await Prefs.setHasAgreedToCustomerService();
              Util.customerService(widget.message);
              Navigation(context).pop();
            })
      ],
    );
  }

  Widget _checkboxText() => Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: BodyText(string('shared_dont_show_this_again')));

  Widget _title() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: Text(string('customer_service_dialog_title')));

  Widget _content() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
      child: Text(string('customer_service_dialog_content')));

  Widget _checkbox() => Padding(
      padding: EdgeInsets.only(left: 8.0, top: 8.0),
      child: Checkbox(
          value: showNoMore,
          onChanged: (bool newValue) {
            setState(() {
              showNoMore = newValue;
            });
          }));
}
