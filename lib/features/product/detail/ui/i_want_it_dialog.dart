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
  final bool isAuthenticated;

  const IWantItDialog(
      {Key key, this.phoneNumber, this.message, this.isAuthenticated})
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
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 8.0, vertical: Dimens.default_vertical_margin),
            child: Body2Text(string('i_want_it_dialog_title'), textAlign: TextAlign.center)
          ),
          Divider(
            height: 1.0,
          ),
          ListTile(
            leading: Icon(CustomIcons.whatsapp),
            title: Text(string('i_want_it_dialog_whatsapp')),
            onTap: _startWhatsApp,
          ),
          Divider(
            height: 1.0,
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(string('i_want_it_dialog_call')),
            onTap: _startPhoneApp,
          ),
          Divider(
            height: 1.0,
          ),
          _termsOfService()
        ],
      ),
    );
  }

  Widget _termsOfService() {
    if (widget.isAuthenticated) return Container();

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 8.0, vertical: Dimens.default_vertical_margin),
      child: TermsOfServiceAcceptanceCaption(
        prefix: 'terms_acceptance_caption_by_contacting_',
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
