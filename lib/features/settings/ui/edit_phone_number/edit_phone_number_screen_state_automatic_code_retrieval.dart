import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/shared/change_number_button.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/colors.dart';
import 'package:giv_flutter/values/dimens.dart';

class EditPhoneNumberScreenStateAutomaticCodeRetrieval extends StatelessWidget {
  final String phoneNumber;
  final Function onChangedNumberButtonTapped;
  final Function onManuallyEnterCodeButtonTapped;

  const EditPhoneNumberScreenStateAutomaticCodeRetrieval({
    Key key,
    @required this.phoneNumber,
    @required this.onChangedNumberButtonTapped,
    @required this.onManuallyEnterCodeButtonTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        H6Text(
          stringFunction(
            'settings_edit_phone_number_auto_retrieval_screen_title',
          ),
        ),
        Spacing.vertical(Dimens.default_vertical_margin),
        Body2Text(
          stringFunction(
            'settings_edit_phone_number_auto_retrieval_screen_message',
            formatArg: phoneNumber,
          ),
          color: CustomColors.lighterTextColor,
        ),
        Spacing.vertical(64.0),
        LinearProgressIndicator(),
        Spacing.vertical(64.0),
        ChangedNumberButton(
          onTap: onChangedNumberButtonTapped,
        ),
        DefaultVerticalSpacing(),
        ManuallyEnterCodeButton(
          onTap: onManuallyEnterCodeButtonTapped,
        )
      ],
    );
  }
}

class ManuallyEnterCodeButton extends StatelessWidget {
  final GestureTapCallback onTap;

  const ManuallyEnterCodeButton({
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
            'settings_edit_phone_number_auto_retrieval_screen_i_want_to_type_code_button',
          ),
          color: CustomColors.textLinkColor,
        ),
      ),
    );
  }
}
