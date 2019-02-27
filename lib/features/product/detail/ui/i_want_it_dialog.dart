import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/util/presentation/termos_of_service_acceptance_caption.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:giv_flutter/values/custom_icons_icons.dart';
import 'package:giv_flutter/values/dimens.dart';

class IWantItDialog extends StatefulWidget {
  final String phoneNumber;
  final String message;

  const IWantItDialog({Key key, this.phoneNumber, this.message})
      : super(key: key);

  @override
  _IWantItDialogState createState() => _IWantItDialogState();
}

class _IWantItDialogState extends BaseState<IWantItDialog> {
  String _phoneNumber;

  @override
  void initState() {
    super.initState();
    _phoneNumber = widget.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: Dimens.default_vertical_margin),
          child: Body2Text(string('i_want_it_dialog_title')),),
          Divider(height: 1.0,),
          ListTile(
            leading: Icon(CustomIcons.whatsapp),
            title: Text(string('i_want_it_dialog_whatsapp')),
            onTap: _startWhatsApp,
          ),
          Divider(height: 1.0,),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(string('i_want_it_dialog_call')),
            onTap: _startPhoneApp,
          ),
          Divider(height: 1.0,),
          Padding(padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: Dimens.default_vertical_margin),
          child: TermsOfServiceAcceptanceCaption(textAlign: TextAlign.center,),)
        ],
      ),
    );
  }

  _startWhatsApp() {
    Util.openWhatsApp(_phoneNumber, widget.message);
  }

  _startPhoneApp() {
    Util.openPhoneApp(_phoneNumber);
  }
}
