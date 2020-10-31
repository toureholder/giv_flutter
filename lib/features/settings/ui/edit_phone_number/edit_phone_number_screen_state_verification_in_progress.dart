import 'package:flutter/material.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';

class EditPhoneNumberScreenStateVerificationInProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DefaultVerticalSpacingAndAHalf(),
          SizedBox(
            width: 64.0,
            height: 64.0,
            child: CircularProgressIndicator(
              strokeWidth: 6.0,
            ),
          ),
          DefaultVerticalSpacingAndAHalf(),
          Body2Text(
            stringFunction(
              'settings_edit_phone_number_validating_code_screen_title',
            ),
          ),
        ],
      ),
    );
  }
}
