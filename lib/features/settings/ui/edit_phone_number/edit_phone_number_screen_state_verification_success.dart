import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';

class EditPhoneNumberScreenStateVerificationSuccess extends StatelessWidget {
  final VoidCallback onConfrimationButtonPressed;

  const EditPhoneNumberScreenStateVerificationSuccess({
    Key key,
    @required this.onConfrimationButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DefaultVerticalSpacing(),
          Icon(
            Icons.check_circle_outline_rounded,
            color: Colors.green,
            size: 96.0,
          ),
          DefaultVerticalSpacing(),
          H4Text(
            stringFunction(
              'settings_edit_phone_number_validation_complete_screen_title',
            ),
          ),
          DefaultVerticalSpacing(),
          Body2Text(
            stringFunction(
              'settings_edit_phone_number_validation_complete_screen_message',
            ),
          ),
          DefaultVerticalSpacing(),
          DefaultVerticalSpacing(),
          EditPhoneNumberScreenStateVerificationSuccessOkButton(
            onPressed: onConfrimationButtonPressed,
          ),
        ],
      ),
    );
  }
}

class EditPhoneNumberScreenStateVerificationSuccessOkButton
    extends StatelessWidget {
  final VoidCallback onPressed;

  const EditPhoneNumberScreenStateVerificationSuccessOkButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: GetLocalizedStringFunction(context)('common_ok'),
      onPressed: onPressed,
    );
  }
}
