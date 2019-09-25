import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/presentation/custom_divider.dart';
import 'package:giv_flutter/util/presentation/custom_divider.dart';
import 'package:giv_flutter/util/presentation/custom_divider.dart';
import 'package:giv_flutter/util/presentation/termos_of_service_acceptance_caption.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:giv_flutter/values/custom_icons_icons.dart';
import 'package:giv_flutter/values/dimens.dart';

class IWantItDialog extends StatefulWidget {
  final String phoneNumber;
  final String message;
  final bool isAuthenticated;
  final Util util;

  const IWantItDialog({
    Key key,
    @required this.util,
    this.phoneNumber,
    this.message,
    this.isAuthenticated,
  }) : super(key: key);

  @override
  _IWantItDialogState createState() => _IWantItDialogState();
}

class _IWantItDialogState extends BaseState<IWantItDialog> {
  String _phoneNumber;
  Util _util;

  @override
  void initState() {
    super.initState();
    _util = widget.util;
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
              child: Body2Text(string('i_want_it_dialog_title'),
                  textAlign: TextAlign.center)),
          CustomDivider(),
          StartWhatsAppTile(
            onTap: _startWhatsApp,
          ),
          CustomDivider(),
          StartPhoneAppTile(
            onTap: _startPhoneApp,
          ),
          CustomDivider(),
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
        util: _util,
        prefix: 'terms_acceptance_caption_by_contacting_',
      ),
    );
  }

  _startWhatsApp() {
    _util.openWhatsApp(_phoneNumber, widget.message);
  }

  _startPhoneApp() {
    _util.openPhoneApp(_phoneNumber);
  }
}

class StartWhatsAppTile extends StatelessWidget {
  final GestureTapCallback onTap;

  const StartWhatsAppTile({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(CustomIcons.whatsapp),
      title: Text(
        GetLocalizedStringFunction(context)('i_want_it_dialog_whatsapp'),
      ),
      onTap: onTap,
    );
  }
}

class StartPhoneAppTile extends StatelessWidget {
  final GestureTapCallback onTap;

  const StartPhoneAppTile({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.phone),
      title: Text(
        GetLocalizedStringFunction(context)('i_want_it_dialog_call'),
      ),
      onTap: onTap,
    );
  }
}
