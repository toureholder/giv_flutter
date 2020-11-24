import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/util/presentation/custom_divider.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
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
  final bool isMailable;
  final Location location;

  const IWantItDialog({
    Key key,
    @required this.util,
    @required this.phoneNumber,
    @required this.message,
    @required this.isAuthenticated,
    @required this.isMailable,
    this.location,
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
          IWantItDialogTitle(),
          CustomDivider(),
          StartWhatsAppTile(
            onTap: _startWhatsApp,
          ),
          CustomDivider(),
          if (!widget.isMailable)
            IWantItDialogNoShippingAlert(
              location: widget.location,
            ),
          if (!widget.isAuthenticated)
            IWantItDialogTermsOfService(
              util: _util,
            ),
          if (!widget.isMailable || !widget.isAuthenticated)
            DefaultVerticalSpacing(),
        ],
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

class IWantItDialogTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0.0,
              vertical: Dimens.grid(8),
            ),
            child: Body2Text(
              stringFunction('i_want_it_dialog_title'),
              color: Colors.white,
              weight: SyntheticFontWeight.semiBold,
            ),
          ),
        ],
      ),
    );
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

class IWantItDialogTermsOfService extends StatelessWidget {
  final Util util;

  const IWantItDialogTermsOfService({Key key, @required this.util})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DefaultVerticalSpacing(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          child: TermsOfServiceAcceptanceCaption(
            util: util,
            prefix: 'terms_acceptance_caption_by_contacting_',
          ),
        ),
      ],
    );
  }
}

class IWantItDialogNoShippingAlert extends StatelessWidget {
  final Location location;

  const IWantItDialogNoShippingAlert({Key key, this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    final text = location == null
        ? stringFunction('product_detail_no_shipping_alert_null_location')
        : stringFunction('product_detail_i_want_it_dialog_no_shipping_alert',
            formatArg: location?.mediumName);

    return Column(
      children: <Widget>[
        DefaultVerticalSpacing(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          child: Body2Text(
            text,
            textAlign: TextAlign.center,
            weight: SyntheticFontWeight.semiBold,
          ),
        ),
      ],
    );
  }
}
