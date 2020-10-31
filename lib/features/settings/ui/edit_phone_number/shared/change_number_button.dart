import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/colors.dart';

class ChangedNumberButton extends StatelessWidget {
  final GestureTapCallback onTap;

  const ChangedNumberButton({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(top: 6.0, right: 6.0, bottom: 6.0),
        color: Colors.transparent,
        child: Body2Text(
          stringFunction(
            'settings_edit_phone_number_shared_change_number_button',
          ),
          color: CustomColors.textLinkColor,
        ),
      ),
    );
  }
}
